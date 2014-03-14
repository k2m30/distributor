class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]
  has_many :groups, dependent: :destroy

  def get_all_items_json
    Item.order(:name).pluck(:name).to_json
  end

  def all_sites_import(filename)
    spreadsheet = Roo::Excelx.new(filename)
    @header = spreadsheet.row(1)
    @rows = []
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[@header, spreadsheet.row(i)].transpose]
      site = Site.where(name: row['name']).first || Site.new

      site.attributes = row.to_hash
      site.save!
    end
    if filename.include?('tmp')
      File.delete(filename)
    end
    Site.all.each { |site| site.touch }
  end

  def standard_site_import(filename)
    #site = Site.where(standard: true).first || create_new_standard_site
    #TODO make several standard sites and check all standard occurences

    site = Site.joins(:groups).where(standard: true, groups: {'user' => self}).uniq.first || create_new_standard_site
    spreadsheet = Roo::Excelx.new(filename)
    spreadsheet.sheets.each do |sheet|
      spreadsheet.default_sheet = sheet
      @header = spreadsheet.row(1)
      group = Group.where(name: sheet, 'user' => self).first || create_new_group(sheet, site, self)
      site.groups << group if !site.groups.include?(group)

      (2..spreadsheet.last_row).each do |i|
        row = Hash[[@header, spreadsheet.row(i)].transpose]
        if !row['item_id'].nil?
          item = group.items.find_by(name: row['item_id']) || create_new_item(row['item_id'], group)
        else
          next
        end

        price = row['price']
        if !item.nil? && !site.nil?
          set_price(item, site, price)
          item.standard_price = price
          item.save
        end
      end
      group.settings.last_updated = Time.now
      group.settings.save
    end

    if filename.include?('tmp')
      File.delete(filename)
    end
    Site.all.each { |site| site.touch }
  end

  def shops_file_import(filename)
    spreadsheet = Roo::Excelx.new(filename)
    spreadsheet.sheets.each do |sheet|
      spreadsheet.default_sheet = sheet
      group = Group.where(name: sheet, 'user' => self).first
      next if group.nil?
      sites = group.sites.where(standard: [false, nil])
      group.sites.delete(sites)
      (2..spreadsheet.last_row).each do |i|
        site = Site.where(name: spreadsheet.row(i)[0]).first
        group.sites << site if !site.nil? && !group.sites.include?(site)
      end

      group.save
      logger.warn ['----------------------', group.name, group.sites.size]
    end
    if filename.include?('tmp')
      File.delete(filename)
    end
    Site.all.each { |site| site.touch }
    Item.all.each { |item| item.touch }
    Group.all.each { |group| group.touch }
  end

  private

  def create_new_standard_site
    site = Site.new
    site.name = 'Standard'
    site.standard = true
    site.save

    return site
  end

  def create_new_item(name, group)
    item = Item.new
    item.name = name
    item.group = group
    item.save

    return item
  end

  def create_new_group(name, site, user)
    group = Group.new
    group.name = name
    group.user = user
    group.sites << site
    group.save

    settings = Settings.new
    settings.group = group
    settings.save

    return group
  end

  def set_price (item, site, price)
    url = (item.urls & site.urls).first || Url.new
    url.site = site
    url.item = item
    url.price = price
    url.url = '#' if url.url.nil?
    url.save
  end

end
