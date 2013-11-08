require 'zip/zip'
require 'rubyXL'
require 'axlsx'

class SitesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy]


  def export()
    sites = Site.all
    create_sites_file(sites)
    users = User.all
    create_user_folders(users)

    create_zip_folder
    redirect_to sites_path
  end


  def export_preview
    @sites = ["_sites", Site.all]
    @folders = []

    @users = User.all.order("username")
    @users.each do |user|
      user_folders = []
      user.groups.each do |group|
        user_folders << [group.name, group.items.order("name"), group.sites.order("name"), "standard.xlsx"]
      end
      @folders << [user.username, user_folders]
    end

  end

  def imprort_css
    #Hash[[@header, spreadsheet.row(i)].transpose]
    #product = find_by_id(row["id"]) || new
    #product.attributes = row.to_hash.slice(*accessible_attributes)
    #product.save!
  end

  def import

    redirect_to sites_path, notice: "Импортировано"
  end

  def import_sites(folder)
    Dir.chdir(folder) do
      spreadsheet = Roo::Excelx.new('all_sites.xlsx', nil, :ignore)
      @header = spreadsheet.row(1)
      @rows = []
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[@header, spreadsheet.row(i)].transpose]
        site = Site.find_by_id(row["id"]) || Site.new

        site.attributes = row.to_hash #.slice(*accessible_attributes)
        site.save!
      end
    end
  end

  def import_standard_prices(folder)
    Dir.chdir(folder) do
      site = Site.where(standard: true).first
      spreadsheet = Roo::Excelx.new('standard.xlsx')
      spreadsheet.sheets.each do |sheet|
        spreadsheet.default_sheet = sheet
        @header = spreadsheet.row(1)
        group = Group.where(name: sheet).first
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[@header, spreadsheet.row(i)].transpose]
          item = group.items.where(name: row["item_id"]).first
          price = row["price"]
          if !item.nil? && !site.nil?
            set_price(item, site, price)
          end
        end
      end

    end
  end
  def import_group_items(user, group, spreadsheet)
    p group.items.size
    @header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[@header, spreadsheet.row(i)].transpose]
      item = Item.where(name: row["name"]).first
      group.items << items if !item.nil? && !group.items.include?(item)
    end
    p group.items.size
  end

  def import_group_sites(user, group, spreadsheet)
    @header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[@header, spreadsheet.row(i)].transpose]
      site = Site.where(name: row["name"]).first
      group.sites << site if !site.nil? && !group.sites.include?(site)
    end
  end

  def import_user_data(folder)
    Dir.chdir(folder) do
      Dir.glob("*").each do |file_name|
        user = User.where(username: file_name)
        if !user.empty?
          user = user.first
          Dir.chdir(file_name) do
            Dir.glob("*").each do |group_name|
              group = Group.where(name: group_name)
              if !group.empty?
                Dir.chdir(group_name) do
                  group = group.first
                  items_file = Roo::Excelx.new('items.xlsx')
                  sites_file = Roo::Excelx.new('sites.xlsx')
                  import_group_items(user, group, items_file)
                  import_group_sites(user, group, sites_file)
                end
              end
            end
          end
        end
      end
    end
  end

  def import_preview
    @site = params[:file]
    if @site.nil?
      redirect_to sites_path, alert: "Выберите файл"
      return
    end

    tmp_folder = './tmp/export/'
    unzip_file(@site.tempfile, tmp_folder)
    sites = import_sites(tmp_folder+'_sites/')
    user_data = import_user_data(tmp_folder)
    import_standard_prices(tmp_folder+'_sites/')
    #spreadsheet = Roo::Excelx.new(@site.path, nil, :ignore)
    #@header = spreadsheet.row(1)
    #@rows = []
    #(2..spreadsheet.last_row).each do |i|
    #  @rows << spreadsheet.row(i)
    #end

  end

  def index
    @sites = Site.all.order("name")
  end

  def show
    @urls = []
    @site.groups.order("name").each do |group|
      group_urls = @site.urls.find_all { |url| url.item.get_group_name == group.name }
      @urls += group_urls.sort_by { |url| url.item.name }
    end
  end

  def new
    @site = Site.new
  end

  def edit
  end

  def create
    @site = Site.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
        format.json { render action: 'show', status: :created, location: @site }
      else
        format.html { render action: 'new' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end

  def stop_list
    @groups = Group.order("name")
    @sites = Site.where(violator: true).order("name")
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = Site.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    params.require(:site).permit! #(:name, :regexp, :standard, :company_name, :out_of_ban_time, :email, urls: :url, :items)
  end

  def mkdir(dirname, permissions=0755)
    begin
      Dir.mkdir(dirname, permissions)
    rescue => e
      p e.inspect
    end
  end

  def create_sites_file (sites)
    permissions = 0755
    p Dir.pwd
    mkdir("export", permissions)
    Dir.chdir("export") do
      p Dir.pwd

      mkdir("_sites", permissions)
      Dir.chdir("_sites") do
        p Dir.pwd

        Axlsx::Package.new do |p|
          p.workbook.add_worksheet(:name => "all_sites") do |sheet|
            sheet.add_row Site.first.attributes.keys
            sites.each do |site|
              row = site.attributes.values
              sheet.add_row row
            end
          end
          p.serialize("all_sites.xlsx")
        end

        standard_site = sites.where(standard: true).first
        Axlsx::Package.new do |p|
          standard_site.groups.order("name").each do |group|
            p.workbook.add_worksheet(name: group.name) do |sheet|
              sheet.add_row ["group_id", "item", "price"]
              group_items = standard_site.items.find_all { |item| item.get_group_name == group.name }
              group_items = group_items.sort_by { |item| item.name }
              group_items.each { |item| sheet.add_row [group.name, item.name, get_price(standard_site, item)] }
            end
          end
          p.serialize("standard.xlsx")
        end
      end
    end
  end

  def create_user_folders(users)
    Dir.chdir("export") do
      users.each do |user|
        mkdir(user.username)
        Dir.chdir(user.username) do
          user.groups.each do |group|
            mkdir(group.name)
            Dir.chdir(group.name) do
              #items.xlsx
              Axlsx::Package.new do |p|
                p.workbook.add_worksheet(:name => "items") do |sheet|
                  sheet.add_row ["name"]
                  group.items.order("name").each { |item| sheet.add_row [item.name] }
                end
                p.serialize("items.xlsx")
              end

              #sites.xlsx
              Axlsx::Package.new do |p|
                p.workbook.add_worksheet(:name => "sites") do |sheet|
                  sheet.add_row ["name"]
                  group.sites.order("name").each { |site| sheet.add_row [site.name] }
                end
                p.serialize("sites.xlsx")
              end

            end
          end
        end
      end
    end
  end

  def create_zip_folder
    directory = './export/'
    zipfile_name = './export_file.zip'

    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      Dir[File.join(directory, '**', '**')].each do |file|
        zipfile.add(file.sub(directory, ''), file)
      end
    end

  end

  def unzip_file (file, destination)
    Zip::ZipFile.open(file) { |zip_file|
      zip_file.each { |f|
        f_path=File.join(destination, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      }
    }
  end

end
