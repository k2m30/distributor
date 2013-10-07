# encoding: UTF-8
require 'open-uri'
require "nokogiri"
require 'rubyXL'


class UrlsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_url, only: [:show, :edit, :update, :destroy]

  # GET /urls
  # GET /urls.json
  def index
    group = Group.where(name: "MTD").first
    items = group.items
    @urls = []
    items.each do |item|
      @urls += item.urls
    end

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
    urls = params[:site].nil? ? Url.all : Site.find(params[:site]).urls.all

    urls.each do |url|
      #logger.error(url.id)
      #if url.id == 1584

      begin
        uri = URI.parse(url.url) #.encode("utf-8"))
        puts "---"
        puts uri
        page = open(uri, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 OPR/16.0.1196.73", "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Cache-Control" => "max-age=0")
        html = Nokogiri::HTML page
        price = html.at_css(url.site.css).content.gsub(/\u00a0|\s/,"")
        p price
        r = Regexp.new(url.site.regexp)
        price = price.mb_chars.downcase.to_s[r]#[/\d+\D*руб/].gsub("руб","")[/\d+/]
        p r
        p price
        url.price = price
        url.save if url.changed?
      rescue
        url.price = -1
        url.save
        logger.error(url.url)
        logger.error("#{$!}")
      end


    end

    update_violators (false)
    current_user.settings.last_updated = Time.now
    current_user.settings.save
    flash[:notice] = "Цены обновлены"
    redirect_to sites_path
  end

  def update_violators (redirect_to_root=true)
    sites = Site.all
    sites.each do |site|
      if !site.out_of_ban_time.nil?
        if Time.now > site.out_of_ban_time
          site.violator = false
          if !site.regexp.class == Regexp
            site.regexp = Regexp.new(site.regexp)
          end
          site.save if site.changed?
        end
      end
    end

    items = Item.all
    Group.all.each do |group|


      standard_site = group.sites.where(:standard => true)
      if standard_site.nil? || standard_site.empty?
        return
      end

      standard_site = standard_site.first
      items.each do |item|
        standard_price = get_price(item, standard_site)
        if !standard_price.nil?
          item.urls.each do |url|
            if !url.price.nil?
              #logger.error(url.price)
              url.violator = (url.price < (standard_price - current_user.settings.allowed_error) && url.price > 0) ? true : false

              if url.violator?
                if !url.site.violator?
                  site = url.site
                  site.violator = true
                  site.out_of_ban_time = Time.now + 1.days
                  logger.error("--")
                  if !site.regexp.class == Regexp
                    site.regexp = Regexp.new(site.regexp)
                  end

                  site.save if site.changed?
                end
              end

              url.save if url.changed?
            end

          end
        end
      end
    end

    flash[:notice] = "Нарушители обновлены"
    if redirect_to_root
      redirect_to root_path
    end

  end

  def find_urls
    # http://yandex.by/yandsearch?text=mtd+827+ast&site=gepard.by
    # http://www.google.by/search?num=10&q=mtd+827+ast+site:gepard.by
    # http://search.tut.by/?status=1&ru=1&encoding=1&page=0&how=rlv&query=mtd+827+ast+site%3Agepard.by
    # http://nova.rambler.ru/search?utm_source=nhp&query=mtd+827+ast+site%3Agepard.by
    # http://search.aol.com/aol/search?enabled_terms=&s_it=comsearch51&q=mtd+827+ast+site%3Agepard.by
    # http://www.nigma.ru/?s=mtd+827+ast+site%3Agepard.by
    # http://www.genon.ru/GetAnswer.aspx?QuestionText=mtd%20827%20ast%20site:gepard.by
    i = 0
    j = 0
    z = 0
    item_url = nil
    url_column = "URL"
    site_param = "SITE"
    css = "CSS"
    banned = "BANNED"
    current_engine = 0
    file_name = "/Users/Mikhail/RubymineProjects/distibutor/config/search/search_engines.xlsx"
    clients = ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 OPR/16.0.1196.73",
               ""]

    workbook = RubyXL::Parser.parse(file_name)
    table = workbook[0].get_table([url_column, site_param, css, banned])
    groups = Group.all
    logger.error("Started at " + Time.now.to_s)

    groups.each do |group|
      group.sites.each do |site|
        group.items.each do |item|
          z = z + 1
          current_engine = rand(2..table.values[0].size)-2
          if get_url(item, site).nil? || get_url(item, site).empty? && !(table.values[0][current_engine][banned] == "+")
            #create search query
            search_query = (table.values[0][current_engine][url_column] + group.name+ "+" + (item.name + table.values[0][current_engine][site_param] + site.name).gsub(/[\ \/]/, '+')).gsub("&amp;", '&')

            #find url for item
            begin
              uri = URI.parse(search_query) #.encode("utf-8"))
              puts "---"
              puts table.values[0][current_engine][css]
              puts uri
              page = open(uri, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 OPR/16.0.1196.73", "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Cache-Control" => "max-age=0")
              html = Nokogiri::HTML page
              item_url = html.at_css(table.values[0][current_engine][css])[:href][/http:\/\/.*/]
              sleep_time = rand(200..700)/100

              i = i + 1
              sleep(sleep_time)
            rescue Exception => e
              puts e
              if item_url.nil?
                #workbook.worksheets[0][current_engine][3].change_contents("+")
                #workbook.write(file_name)
                puts workbook.worksheets[0][current_engine][0].to_s + "Banned at " + Time.now.to_s
              end

              j = j + 1
            end

            #create url, save url and item
            if !item_url.nil? && !item_url.empty?
              url = Url.new
              url.url = item_url
              url.site = site
              item.urls << url
              url.save
              item.save

              puts url.inspect
              item_url = nil
            end
            #redirect_to urls_path

          end

        end
      end
      puts i
      puts j
      puts z
    end
    logger.error("Finished at " + Time.now.to_s)
    redirect_to urls_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.



  def refine (regexp)
    # debugger
    return Regexp.new (regexp.encode("utf-8").gsub("\\", ""))
  end


  def set_url
    @url = Url.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def url_params
    params.require(:url).permit!#(:url, :price, :site, :item)
  end


end
