# encoding: UTF-8
require 'open-uri'
require 'nokogiri'
require 'rubyXL'


class UrlsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_url, only: [:show, :edit, :update, :destroy, :update_single_price]
  #after_update_prices :expire_cache

  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.joins(:item => :group).where('groups.user_id = ?', current_user.id).paginate(:page => params[:page], :per_page => 100)
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
  end

  # GET /urls/new
  def new
    @url = Url.new
  end

  # GET /urls/1/edit
  def edit
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)

    respond_to do |format|
      if @url.save
        format.html { redirect_to @url, notice: 'Url was successfully created.' }
        format.json { render action: 'show', status: :created, location: @url }
      else
        format.html { render action: 'new' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /urls/1
  # PATCH/PUT /urls/1.json
  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1
  # DELETE /urls/1.json
  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url }
      format.json { head :no_content }
    end
  end

  def update_prices
    current_site = params[:site].nil? ? nil : Site.find(params[:site])
    if ENV['RACK_ENV'] == 'production' || ENV['RAILS_ENV'] == 'production' || ENV['USER'] == 'deployer'
      current_site.delay(run_at: 10.seconds.from_now).update_prices
    else
      current_site.update_prices
    end
    #sdf
    #LogMailer.update_report(current_site).deliver

    flash[:notice] = "Цены обновляются. Обычно это занимает 1-2 минуты для каждого сайта. Обновите страницу позже."


    redirect_to site_path(current_site)

  end

  def update_violators (redirect_to_root=true, site_id=nil)
    allowed_error = current_user.settings.allowed_error
    if site_id.nil?
      groups = Group.all
      all_sites = Site.all
    else
      current_site = Site.find(site_id)
      groups = current_site.groups
      all_sites = [current_site]
    end
    p groups.count
    groups.each do |group|
      if site_id.nil?
        items = group.items
        standard_site = group.sites.where(:standard => true).first
      else
        items = current_site.items & group.items
        standard_site = current_site.groups[0].sites.where(:standard => true).first
      end

      if standard_site.nil?
        return
      end

      p items.count
      items.each do |item|
        standard_price = get_price(item, standard_site)
        if !standard_price.nil? && standard_price > 0
          urls = site_id.nil? ? item.urls : current_site.urls & item.urls
          urls.each do |url|
            if !url.price.nil?
              #p "----", item.name, url.url, "%.1f" % url.price, "%.1f" % standard_price
              url.delay(run_at: 3.seconds.from_now).check_for_violation(standard_price, allowed_error)
              #p url.violator?
            end
          end
        else
          item.urls.each do |url|
            url.violator = false
            url.save if url.changed?
          end

        end
      end
    end

    all_sites.each do |site|
      site.delay(run_at: 3.seconds.from_now).check_for_violation
      p site.violator?
    end

    flash[:notice] = 'Список нарушителей обновляется'
    if redirect_to_root
      redirect_to root_path
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.


  def refine (regexp)
    # debugger
    return Regexp.new (regexp.encode('utf-8').gsub("\\", ''))
  end


  def set_url
    @url = Url.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def url_params
    params.require(:url).permit! #(:url, :price, :site, :item)
  end

  def expire_cache
    expire_fragment('stop_list')
  end


end
