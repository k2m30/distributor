require 'zip/zip'
require 'rubyXL'
require 'axlsx'

class SitesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy, :logs, :logs_submit]


  def logs
    @logs = @site.logs.order(:message)
    @names = Item.all.order(:name).pluck(:id, :name)
  end

  def logs_submit
    @site.logs.each do |log|
      url = Url.find_by_url(log.message.split(", ")[1].gsub("\"", ""))
      if url.nil?
        item = Item.find_by_name(log.name_found)
        next if item.nil?

        url = @site.update_url(log.price_found, log.message.split(", ")[1].gsub("\"", ""), item)
        #url.locked = true
        #url.save
      else
        item = Item.find_by_name(log.name_found)
        next if item.nil?

        next if item.name == log.name_found

        url.item = item
        url.locked = true
        url.save

      end

    end

    redirect_to site_path(@site)

  end

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

  def index
    @sites = Site.all.order("name")
  end

  def show
   @urls = @site.urls.joins(item: :group).order('groups.name ASC, items.name ASC')
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
    @groups = current_user.groups.order("name")
    @sites = Site.joins(:groups).where(violator: true, groups: {'user' =>  current_user}).uniq.order(:name)
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
