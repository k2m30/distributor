class SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_setting, only: [:show, :edit, :update, :destroy]


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

  def create_new_item(name, group)
    item = Item.new
    item.name = name
    item.group = group
    item.save

    return item
  end

  def create_new_standard_site
    site = Site.new
    site.name = 'Standard'
    site.standard = true
    site.save

    return site
  end

  def import_user_sites_preview
    begin
      @shops = params[:shops]
      if @shops.nil?
        redirect_to settings_path, alert: 'Выберите файл'
        return
      end

      @sites = []
      spreadsheet = Roo::Excelx.new(@shops.path, nil, :ignore)
      spreadsheet.sheets.each do |sheet|
        spreadsheet.default_sheet = sheet
        group = Group.where(name: sheet).first
        next if group.nil?

        (2..spreadsheet.last_row).each do |i|
          @sites << [sheet, spreadsheet.row(i)[0]]
        end
      end

      File.open('./tmp/' + current_user.username + '_shops' + '.xlsx', 'w') do |tempfile|
        tempfile.write(@shops.tempfile.set_encoding('utf-8').read)
      end
    rescue
      redirect_to settings_path, alert: 'Произошла ошибка импорта.'
    end

  end      #список магазинов по группам

  def import_user_sites
    begin
      spreadsheet = Roo::Excelx.new('./tmp/' + current_user.username + '_shops'+'.xlsx', nil, :ignore)
      spreadsheet.sheets.each do |sheet|
        spreadsheet.default_sheet = sheet
        group = Group.where(name: sheet).first
        next if group.nil?
        group.sites.delete_all

        (2..spreadsheet.last_row).each do |i|
          site = Site.where(name: spreadsheet.row(i)[0]).first
          group.sites << site if !site.nil? && !group.sites.include?(site)
        end

        group.save
      end

      File.delete('./tmp/' + current_user.username + '_shops'+ '.xlsx')
      redirect_to settings_path, success: 'Список могазинов обновлен.'

    rescue
      redirect_to settings_path, alert: 'Произошла ошибка импорта.'
    end
  end #список магазинов по группам

  def import_standard_prices_preview
    begin
      @file = params[:file]
      if @file.nil?
        redirect_to settings_path, alert: 'Выберите файл'
        return
      end

      @items = []
      spreadsheet = Roo::Excelx.new(@file.path, nil, :ignore)
      spreadsheet.sheets.each do |sheet|
        spreadsheet.default_sheet = sheet
        @header = spreadsheet.row(1)

        (2..spreadsheet.last_row).each do |i|
          row = Hash[[@header, spreadsheet.row(i)].transpose]
          if !row['item_id'].nil?
            @items << [sheet, row['item_id'], row['price']]
          else
            next
          end
        end
      end

      File.open('./tmp/' + current_user.username + '.xlsx', 'w') do |tempfile|
        tempfile.write(@file.tempfile.set_encoding('utf-8').read)
      end
    rescue
      redirect_to settings_path, alert: 'Произошла ошибка импорта.'
    end


  end #стандартные цены

  def import_standard_prices

    begin
      site = Site.where(standard: true).first || create_new_standard_site

      spreadsheet = Roo::Excelx.new('./tmp/' + current_user.username + '.xlsx', nil, :ignore)
      spreadsheet.sheets.each do |sheet|
        spreadsheet.default_sheet = sheet
        @header = spreadsheet.row(1)
        group = Group.where(name: sheet).first || create_new_group(sheet, site, current_user)
        site.groups << group if !site.groups.include?(group)

        (2..spreadsheet.last_row).each do |i|
          row = Hash[[@header, spreadsheet.row(i)].transpose]
          if !row['item_id'].nil?
            item = group.items.where(name: row['item_id']).first || create_new_item(row['item_id'], group)
          else
            next
          end
          price = row['price']
          if !item.nil? && !site.nil?
            set_price(item, site, price)
          end
        end
        group.settings.last_updated = Time.now
        group.settings.save
      end

      File.delete('./tmp/' + current_user.username + '.xlsx')
      redirect_to settings_path, success: 'Цены импортированы'
    rescue
      redirect_to settings_path, alert: 'Произошла ошибка импорта.'
    end
  end #стандартные цены

  def import_sites
    begin
      spreadsheet = Roo::Excelx.new('./tmp/sites_' + current_user.username + '.xlsx', nil, :ignore)
      @header = spreadsheet.row(1)
      @rows = []
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[@header, spreadsheet.row(i)].transpose]
        site = Site.where(name: row['name']).first || Site.new

        site.attributes = row.to_hash
        site.regexp = Regexp.new('\d{4,}').to_s
        site.save!
      end

      File.delete('./tmp/sites_' + current_user.username + '.xlsx')
      redirect_to sites_path, success: 'Информация о сайтах импортирована'
    rescue
      redirect_to settings_path, alert: 'Произошла ошибка импорта.'
    end
  end      #параметры сайтов

  def import_sites_preview(site)
    @file = params[:sites] || site
    if @file.nil?
      redirect_to settings_path, alert: 'Выберите файл'
      return
    end
    begin
      spreadsheet = Roo::Excelx.new(@file.path, nil, :ignore)
      @sites = []
      @header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        @sites << spreadsheet.row(i)
      end
      File.open('./tmp/sites_' + current_user.username + '.xlsx', 'w') do |tempfile|
        tempfile.write(@file.tempfile.set_encoding('utf-8').read)
      end
    rescue
      redirect_to settings_path, alert: 'Произошла ошибка импорта.'
    end

    if !site.nil?
      return [@header, @sites]
    end
  end #параметры сайтов

  def index

    if current_user.admin?
      @groups = Group.all
    else
      @groups = current_user.groups
    end
  end

  def show
  end

  def new
    @setting = Settings.new
  end

  def edit
  end

  def create
    @setting = Settings.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Settings was successfully created.' }
        format.json { render action: 'show', status: :created, location: @setting }
      else
        format.html { render action: 'new' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Settings was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_index_url }
      format.json { head :no_content }
    end
  end

  private
  def set_setting
    @setting = Settings.find(params[:id])

  end

  def setting_params
    params.require(:settings).permit(:ban_time, :last_updated, :allowed_error, :update_time, :rate)
  end

end
