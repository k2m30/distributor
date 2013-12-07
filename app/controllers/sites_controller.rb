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


  def index
    @sites = Site.joins(:groups).where(groups: {'user' =>  current_user}).uniq.order(:name)
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
    @site = Site.joins(:groups).where(id: params[:id], groups: {'user' =>  current_user}).uniq.first
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    params.require(:site).permit! #(:name, :regexp, :standard, :company_name, :out_of_ban_time, :email, urls: :url, :items)
  end

end
