require 'rubygems'
require 'open-uri'
require 'rubyXL'
require 'open-uri'
require "nokogiri"
require "axlsx"

class Site < ActiveRecord::Base
  has_many :urls
  has_many :items, through: :urls
  has_and_belongs_to_many :groups
  has_many :logs

  def check_for_violation
    urls = self.urls.where(violator: true)
    self.violator = urls.empty? ? false : true
    self.save
    p "--", self.name, urls.count, self.violator
    #if !urls.empty?
    #  self.violator = true
    #  if self.out_of_ban_time.nil? || (Time.now > self.out_of_ban_time) #no ban before, or violator with ban time expired
    #    self.out_of_ban_time = Time.now + 1.days
    #  end
    #else
    #  if !self.out_of_ban_time.nil? && (Time.now > self.out_of_ban_time) #ban expired, no violations
    #    self.violator = false
    #    self.out_of_ban_time = nil
    #  end
    #end
    #if self.changed?
    #  self.save
    #end
  end

  def get_violating_urls
    Rails.cache.fetch([self, 'violators']) { self.urls.where(violator: true) }
  end

  def get_items
    Rails.cache.fetch([self, 'items']) { self.items }
  end

  def get_urls
    Rails.cache.fetch([self, 'urls']) { self.urls }
  end

  def get_group_name
    Rails.cache.fetch([self, 'group_name']) { self.groups[0].name }
  end

  def find_violating_urls(group)
    Rails.cache.fetch([self, group, 'urls']) do
      urls = site.urls.where(violator: true).find_all { |url| url.item.get_group_name == group.name }
      urls = urls.sort_by { |url| url.item.name }
    end
  end

  ###################### update price ###################

  def update_prices
    return if self.standard
    begin
      p "------ start update_price ------"
      p "method: " + self.method.to_s
      case self.method.to_i
        when 2
          self.logs.delete_all

          result_array = self.parsing_site
          self.update_urls(result_array)

          self.check_for_violation
        when 1
        else
          p "error get method"
        end
      #rescue => e
      #  p "error update_price"
      #  p e.inspect
      #  Log.create!(message: e.inspect, log_type: "Error", site_id: self.id)
    end

  end

  def update_prices_from_file
    name = "name"
    search_url = "search_url"
    css_item = "css_item"
    css_price = "css_price"
    css_pagination = "css_pagination"

    file = RubyXL::Parser.parse("all_sites.xlsx")
    table_sites = file[0].get_table([name, search_url, css_item, css_price, css_pagination])
    table_sites.values[0].each do |hash|
      if !hash.empty? #проверка на наличие исходных данных
        puts "-----------data file:-----------"
        url_site_array = hash[search_url]
        url_site_array = url_site_array.gsub("amp;", "") #удаление текстового обозначения &
        array = url_site_array.split(/[,]+/)
        url_site_array = array
        css_name = hash[css_item]
        css_p = hash[css_price]
        css_page = hash[css_pagination]
        css_page = "" if css_page.nil? #проверка на отсутствие css пагинации
        css_page = css_page.gsub("amp;", "") #удаление текстового обозначения &
        puts array
        puts css_name
        puts css_p
        puts css_page
        parsing_site(url_site_array, css_name, css_p, css_page)
      end #проверка на наличие исходных данных
    end
  end

  #парсинг с исходными данными из файла

  def check_link(url, start_url) #исправление относительной ссылки
    begin
      site_name = start_url.scan(/(?:[-a-z_\d])+.(?:[-a-z])*(?:\.[a-z]{2,4})+/).first
      site_name = "http://" + site_name
      url_size = url[1..(url.size-1)].split('/').size

      if  url_size > 1 #проверка на редактируемого адреса
        add_str = site_name
      else
        add_str = start_url
      end

      if url.scan(site_name).first.nil? #проверка на относительную ссылку

        if url[0] != "/" && add_str[-1] != "/" #проверка на наличие первого слэша
          str = add_str + "/" + url
        else
          str = add_str + url
        end #проверка на наличие первого слэша

      else
        str = url
      end #проверка на относительную ссылку

      return str

    rescue => e
      puts "error check link"
      puts e.inspect
    end
  end #исправление относительной ссылки

  def save_file(site_name, result_array=[]) #сохранение таблицы в файл xlsx
    begin
      file = Axlsx::Package.new

      file.workbook.add_worksheet(:name => "1") do |sheet|
        sheet.add_row ["NAME", "URL", "PRICE"]

        result_array.each do |product|
          sheet.add_row [product[0], product[1], product[2]]
        end

      end

      file.serialize(site_name + ".xlsx")
      puts "-----------save file: " + site_name + ".xlsx -------------"

    rescue => e
      puts "error save file" + site_name + ".xlsx"
      puts e.inspect
    end
  end  #сохранение таблицы в файл xlsx

  #сохранение таблицы в файл xlsx

  def parsing_site #функция парсинга сайта
    begin
      puts "------ start parsing function " + self.name + "------"

      css_page = self.css_pagination
      css_page = "no" if css_page.nil? || css_page.empty? #присвоение хоть чего нибудь, если значение не передано

      start_page = "http://" + self.name
      referer = start_page
      result_array = []
      site_urls_array = self.search_url.split(/[,]+/)

      site_urls_array.each do |site_url|

        url_site_start = site_url
        previous_page = open(site_url, "Referer" => referer)
        if previous_page.meta["set-cookie"].nil? #присвоение хоть чего нибудь, если cookie отсутсвует     previous_page.meta["set-cookie"]||=""
          previous_page.meta["set-cookie"] = ""
        end #присвоение хоть чего нибудь, если cookie отсутсвует
        if start_page == "http://technostil.by" #затычка для technostil.by
          previous_page.meta["set-cookie"] = ""
        end #затычка для technostil.by

        puts "------------"
        begin
          puts site_url
          page = open(site_url, "Cookie" => previous_page.meta["set-cookie"], "Referer" => referer)
          html = Nokogiri::HTML page
          name_array = html.css(self.css_item)
          name_array.each do |name|
            name.content = name.text.strip.gsub('Е', 'E').gsub('Н', 'H').gsub('О', 'O').gsub('Р', 'P').gsub('А', 'A').gsub('В', 'B').gsub('С', 'C').gsub('М', 'M').gsub('Т', 'T').gsub('К', 'K').gsub('Х', 'X').gsub('/', ' ').gsub('\\', ' ')
          end

          r = Regexp.new(self.regexp)
          price_array = html.css(self.css_price)
          price_array.each do |price|
            if price.content.scan(/\d\.\d{3}/).count > 0
              price.content = price.content.gsub('.', '') #костыль специально для kosilka.by
            end

            price.content = price.text.strip.gsub(/\u00a0|\s/, '').gsub('\'','').mb_chars.downcase.to_s[r]
          end

          if name_array.size != price_array.size #проверка соответствия кол-ва товаров и цен
            puts "----------error---------"
            puts "amount name: " + name_array.size.to_s
            puts "amount price: " + price_array.size.to_s
            last_page = site_url
            next
          end #проверка соответствия кол-ва товаров и цен
          name_array.each_with_index do |product, index|
            str = check_link(product["href"], start_page)
            if start_page == "http://ydachnik.by" #затычка для ydachnik.by
              str = str.gsub("http://ydachnik.by", "http://ydachnik.by/catalog")
            end #затычка для ydachnik.by

            result_array << [product.text, str, price_array[index].text]

            puts product.text

          end #цикл по списку товаров на странице
          puts html.at_css(css_page)
          last_page = site_url
          if !html.at_css(css_page).nil? #проверка на наличие след. страницы
            site_url = html.at_css(css_page)["href"]
            site_url = check_link(site_url, url_site_start)
          end #проверка на наличие след. страницы

        end while !html.at_css(css_page).nil? && site_url != last_page #цикл пагинации

      end #цикл по списку адресов с товаром сайта
      result_array = result_array.sort_by { |item_array| item_array[2].to_f }
      puts "------done parsing function: " + self.name + "------"
      return result_array

    rescue => e
      puts "error parsing site: " + self.name
      puts e.inspect
      Log.create!(message: e.inspect, log_type: "Error", site_id: self.id)
    end
  end

  #функция парсинга сайта

  def update_urls(result_array)
    items = []
    self.groups.each do |group|
      items+=group.items
    end

    self.urls.where(locked: false).destroy_all
    items = items.sort_by { |item| item.name.size }
    items = items.reverse

    result_array.each do |item_array|
      url_str = item_array[1]
      price = item_array[2]
      price = price.to_f < items[0].group.settings.rate ? price.to_f*items[0].group.settings.rate : price.to_f
      url = Url.find_by_url(url_str)

      if url.nil?
        if price == 0
          Log.create!(message: item_array.to_s, price_found: price, name_found: nil,
                      log_type: "No price", site_id: self.id)
          next
        end

        item = find_item(item_array[0], price, items)
        if item.nil?
          Log.create!(message: item_array.to_s, price_found: price, name_found: nil,
                      log_type: "Item not found", site_id: self.id)
          next
        end

        items.delete(item)
        update_url(price, url_str, item)

        Log.create!(message: item_array.to_s, price_found: price, name_found: item.name,
                    log_type: "OK", site_id: self.id)
      else
        items.delete(url.item)
        url.price = price
        url.save if url.changed?
        Log.create!(message: item_array.to_s, price_found: price, name_found: url.item.name,
                    log_type: "OK found in DB", site_id: self.id)
      end
    end

    self.urls.where(locked: true).each do |url|
      url.destroy if !include_locked_url?(result_array, url.url)
    end


    puts "------ update_urls DONE ------"


    self.save
  end

  def include_locked_url?(result_array, url)
    result_array.each do |item_array|
      return true if item_array[1]==url
    end
    false
  end

  def find_item(text, price, items)
    #begin
      #p '------', text
      text = text.downcase.gsub('/', ' ').gsub('.', '').gsub(',', '').gsub('-', ' ')
      text = text.split(' ')
      text = text.keep_if { |word| word.scan(/[а-яА-Я]/).empty? }
      compressed_text = text.join

      items.each do |item|
        item_name = item.name.downcase.gsub('/', ' ').gsub('.', '').gsub(',', '').gsub('-', ' ')
        item_name = item_name.gsub(' ', '')
        if compressed_text.include?(item_name)
          return item if price_fit?(item, price)
        end
      end

      items.each do |item|
        item_name = item.name.downcase.gsub('/', ' ').gsub('.', '').gsub(',', '').gsub('-', ' ')
        item_name = item_name.split(' ')
        if (item_name&text).size == item_name.size
          return item if price_fit?(item, price)
        end
      end

      p 'Не найдено: ' + compressed_text
      return nil

    #rescue => e
    #  p "error find_item"
    #  p e.inspect
    #end
  end

  def price_fit?(item, price)
    standard_price = (item.urls & item.group.sites.where(standard: true).first.urls).first.price
    if (standard_price/price.to_f - 1).abs < 0.4
      true
    else
      false
    end
  end

  def update_url(price, url_str, item)
    url = Url.new
    url.site = self
    url.item = item
    url.url = url_str
    url.price = price.to_f < item.group.settings.rate ? price.to_f*item.group.settings.rate : price.to_f

    url.save

    if item.name.include?('32')
      #dsf
    end


    allowed_error = url.item.group.settings.allowed_error
    allowed_error = allowed_error.include?('%') ? allowed_error.gsub('%', '').to_f/100 * url.price : allowed_error.to_f

    standard_price = url.item.get_standard_price
    #p '---', allowed_error, standard_price
    url.check_for_violation(standard_price, allowed_error)

  end
end

