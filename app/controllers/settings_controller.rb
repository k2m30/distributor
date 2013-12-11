class SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  def export_shops()
    sites = Site.all
    create_sites_file(sites)
    #users = User.all
    #create_user_folders(users)
    #
    #create_zip_folder
    redirect_to sites_path
  end

  def export_shops_preview
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

  end

  #список магазинов по группам

  def import_user_sites(filename='./tmp/' + current_user.username + '_shops'+'.xlsx')
    begin
      current_user.shops_file_import(filename)
      redirect_to settings_path, success: 'Список могазинов обновлен.'

    #rescue
    #  redirect_to settings_path, alert: 'Произошла ошибка импорта.'
    end
  end

  #список магазинов по группам

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


  end

  #стандартные цены

  def import_standard_prices(filename='./tmp/' + current_user.username + '.xlsx')
    begin
      current_user.standard_site_import(filename)
      redirect_to settings_path, success: 'Цены импортированы'
    #rescue
    #  redirect_to settings_path, alert: 'Произошла ошибка импорта.'
    end
  end

  #стандартные цены

  def all_sites_import(filename='./tmp/sites_' + current_user.username + '.xlsx')
    begin
      current_user.all_sites_import(filename)
      redirect_to sites_path, success: 'Информация о сайтах импортирована'
    rescue
      redirect_to settings_path, alert: 'Произошла ошибка импорта.'
    end
  end

  #параметры сайтов

  def all_sites_preview
      @file = params[:sites]
      if @file.nil?
        redirect_to settings_path, alert: 'Выберите файл'
        return
      end
      #begin
        spreadsheet = Roo::Excelx.new(@file.path, nil, :ignore)
        @sites = []

        @header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          @sites << spreadsheet.row(i)
        end
        File.open('./tmp/sites_' + current_user.username + '.xlsx', 'w') do |tempfile|
          tempfile.write(@file.tempfile.set_encoding('utf-8').read)
        end
      #rescue
       # redirect_to settings_path, alert: 'Произошла ошибка импорта.'
      #end
  end

  #параметры сайтов

  def index
    @sites_exist = !Site.all.empty?
    @user_standard_site_exists = !Site.joins(:groups).where(standard: true, groups: {'user' =>  current_user}).uniq.empty?
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
        format.html { redirect_to @setting, notice: 'Настройки успешно обновлены.' }
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

  def mkdir(dirname, permissions=0755)
    begin
      Dir.mkdir(dirname, permissions)
    rescue => e
      p e.inspect
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
