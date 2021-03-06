require 'zip/zip'
require 'rubyXL'
require 'axlsx'

class SitesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy, :logs, :logs_submit, :violators, :update_prices]

  def row
    render text: Site.get_row(params[:id], params[:group])
  end

  def violators
    @violating_urls = @site.get_violating_urls(current_user).includes(item: :group).order('groups.name ASC, items.name ASC')
    render action: "violators", layout: nil
  end

  def logs
    @logs = @site.logs.order(:message)
    @names = Item.all.order(:name).pluck(:id, :name)
  end

  def search
    @items = []
    @item_sort = []
    items = []

    if params[:item_search].present?
      params[:direction] = %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'

      queries = params[:item_search].upcase.gsub(/\s*,\s*/, ',')
      queries.split(',').each do |query|
        items += Item.item_search(query)
      end
      items.compact!
      @items = items.select { |item| item.group.user == current_user }
      redirect_to :back, alert: "#{params[:item_search]} не найден" and return if @items.empty?
      params[:sort] = @items.map(&:name).include?(params[:sort]) ? params[:sort] : @items.first.name
      @item_sort = Item.find_by(name: params[:sort]) || @items.first

    end

  end

  def update_prices
    if Rails.env.production?
      @site.delay(run_at: 10.seconds.from_now).update_prices
    else
      @site.update_prices
    end
    #LogMailer.update_report(current_site).deliver
    flash[:notice] = "Цены обновляются. Обычно это занимает 1-2 минуты для каждого сайта. Обновите страницу позже."

    redirect_to site_path(@site)
  end

  def logs_submit
    @site.logs.each do |log|
      url = Url.find_by_url(log.message.split(", ")[1].gsub("\"", ""))
      if url.nil?
        item = Item.find_by_name(log.name_found)
        next if item.nil?

        url = @site.update_url(log.price_found, log.message.split(", ")[1].gsub("\"", ""), item)
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
    @sites = current_user.admin? ? Site.all.order(:name) : Site.joins(:groups).where(groups: {'user' => current_user}).uniq.order(:name)
  end

  def show
    @urls = @site.urls.joins(item: {group: :user}).where(items: {group_id: current_user.groups.map(&:id)}).order('groups.name ASC, items.name ASC')
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
        format.html { redirect_to @site, notice: 'Сайт успешно обновлен.' }
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
    @sites = Site.get_violators(current_user).paginate(:page => params[:page], :per_page => 10)
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = current_user.admin? ? Site.find(params[:id]) : Site.joins(:groups).where(id: params[:id], groups: {'user' => current_user}).readonly(false).uniq.first
    redirect_to root_path if @site.nil?
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    params.require(:site).permit! #(:name, :regexp, :standard, :company_name, :out_of_ban_time, :email, urls: :url, :items)
  end

end
