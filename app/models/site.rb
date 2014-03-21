require 'rubygems'
require 'open-uri'
require 'rubyXL'
require 'axlsx'
require 'watir-webdriver'
require 'nokogiri'
require 'headless'

class NotLoadedYetError < StandardError;
end
class WrongCSSError < StandardError;
end

class Site < ActiveRecord::Base
  has_many :urls, dependent: :destroy
  has_many :rows, dependent: :destroy
  has_many :items, through: :urls
  has_and_belongs_to_many :groups
  has_many :logs, dependent: :destroy

  def get_urls_count(current_user)
    user_items = Item.joins(group: :user).where(groups: {user_id: current_user.id})
    (user_items & self.items).count
  end

  def check_for_violation
    urls = self.urls.where(violator: true)
    self.violator = urls.empty? ? false : true
    self.save
    p [self.name, 'violators - ', urls.size]
  end

  def get_violating_urls(current_user)
    Rails.cache.fetch([self, 'violators']) {
      #self.urls.where(violator: true).select("urls.urls, urls.price, groups.name, items.name").order('groups.name ASC, items.name ASC')
      #self.urls.where(violator: true)
      self.urls.joins(item: {group: :user}).where(violator: true, items: {group_id: current_user.groups.map(&:id)})

    }
  end

  def get_items
    Rails.cache.fetch([self, 'items']) { self.items }
  end

  def get_urls
    #Rails.cache.fetch([self, 'urls']) { self.urls }
    self.urls
  end

  def find_violating_urls(group)
    Rails.cache.fetch([self, group, 'urls']) do
      urls = site.urls.where(violator: true).find_all { |url| url.item.get_group_name == group.name }
      urls = urls.sort_by { |url| url.item.name }
    end
  end

  def self.get_row(site_id, group_id)
    row = Row.find_by(site_id: site_id, group_id: group_id)
    return row.html if row.present?

    urls = []
    site_urls = Url.where(site_id: site_id).to_a
    Item.where(group_id: group_id).order(:name).includes(:urls).each do |item|
      urls << (site_urls & item.urls.to_a).first
    end

    html = String.new
    urls.each do |url|
      if url.present?
        price = Site.spaces(url.price)
        css_class = !url.violator? ? 'muted' : 'text-error'
        html += "<td><a class=#{css_class} href=#{url.url} target=\"_blank\">#{price}</a></td>"
      else
        html += "<td>-</td>"
      end
    end
    row = Row.create(site_id: site_id, group_id: group_id, html: html)
    return row.html
  end

  def self.get_violators(current_user)
    ids = Url.joins(item: {group: :user}).where(violator: true).where(items: {group_id: current_user.groups.map(&:id)}).map(&:site_id).uniq
    Site.where(id: ids).includes(:urls).order(:name)
  end

  def update_cache
    self.touch
    self.get_items
    self.get_urls
    self.items.each do |item|
      item.get_standard_price
      item.get_standard_url
      item.get_group_name
      item.get_urls
    end
    self.groups.each do |group|
      group.touch
      self.rows.destroy_all
      Site.get_row(self.id, group.id)
    end
    logger.warn '------ cache is updated ------'
  end

###################### update price ###################
  def update_prices
    return if self.standard
    begin
      self.logs.destroy_all
      case self.method.to_i
        when 1
          result_array = self.parsing_site_method1
        when 2
          result_array = self.parsing_site_method2
        else
          logger.error 'error case metod'
          return
      end

      result_array = self.clear_result_array(result_array)
      raise WrongCSSError, self.name if result_array.nil?
      self.update_urls(result_array)

      self.check_for_violation

    rescue => e
      log_error :update_prices, e
      self.update_cache
      return [[], [], []]
    end
    self.update_cache
    logger.warn '------ finished update_price ----- ' + self.name
  end

  def check_link(url, start_url) #исправление относительной ссылки
    begin
      #p "chek_link url = #{url}"
      site_name = start_url.scan(/(?:[-a-z_\d])+.(?:[-a-z])*(?:\.[a-z]{2,4})+/).first
      http_site_name = "http://" + site_name
      url_size = url[1..(url.size-1)].split('/').size
      #p "chek_link site_name = #{site_name}"

      if  url_size > 1 #проверка на редактируемого адреса
        add_str = http_site_name
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
      log_error :check_link, e
      return nil
    end
  end

#исправление относительной ссылки

  def clear_result_array(result_array)
    begin
      if result_array.nil? || result_array.empty?
        return nil
      end
      r = Regexp.new(self.regexp)
      result_array.each do |item_array|
        item_array[0] = item_array[0].strip.gsub('Е', 'E').gsub('Н', 'H').gsub('О', 'O').gsub('Р', 'P').gsub('А', 'A').gsub('В', 'B').gsub('С', 'C').gsub('М', 'M').gsub('Т', 'T').gsub('К', 'K').gsub('Х', 'X').gsub('/', ' ').gsub('\\', ' ')

        if item_array[2].scan(/\d\.\d{3}/).count > 0
          item_array[2] = item_array[2].gsub('.', '') #костыль специально для kosilka.by
        end

        if item_array[2].scan(/\d\,\d{3}/).count > 0
          item_array[2] = item_array[2].gsub(',', '') #костыль специально для rodnoi.by
        end

        item_array[2] = item_array[2].strip.gsub(/\u00a0|\s/, '').gsub('\'', '').mb_chars.downcase.to_s[r]

        if item_array[2].nil?
          item_array[2] = 0
        else
          array = item_array[2].scan(r).sort_by { |elem| elem.to_f }
          case array.size
            when 1..2
              item_array[2] = array[0]
            when 3
              item_array[2] = array[1]
          end
        end

        #logger.warn item_array[0]
        #logger.warn item_array[2].inspect

      end
      result_array = result_array.sort_by { |item_array| item_array[2].to_f }
      logger.warn "------ clear_result_array done ------"
      return result_array
    end
  rescue => e
    log_error :clear_result_array, e
  end

  def parsing_site_method1
    begin
      logger.warn "------ start parsing function method1 " + self.name + "------" + ENV.to_hash.to_s
      if ENV['RACK_ENV'] == 'production' || ENV['RAILS_ENV'] == 'production' || ENV['USER'] == 'deployer'
        logger.error 'Headless started'
        headless = Headless.new
        headless.start
      end
      css_page = self.css_pagination
      css_page = "no" if css_page.nil? || css_page.empty?
      css_item = self.css_item
      css_price = self.css_price
      timeout = 5

      result_array = []

      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['permissions.default.image']=2
      browser = Watir::Browser.new :ff, :profile => profile

      self.search_url.split(/[,]+/).each do |site_url|
        browser.goto site_url
        begin #external exception
          begin #while
            begin # internal exception
              browser.element(:css => css_item).wait_until_present
              result_array += scrap_page(Nokogiri::HTML(browser.html, nil, 'utf-8'), css_item, css_price)
              if result_array.size != result_array.uniq.size
                result_array = result_array.uniq
                raise NotLoadedYetError, 'same page'
              end
              p browser.url
              p 'click'
              next_page_link = browser.element(:css => css_page).when_present(timeout).attribute_value('href')
              browser.element(:css => css_page).when_present(timeout).click
              browser.wait
            rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
              p e.inspect
            rescue NotLoadedYetError => e
              p e.inspect
            end # internal exception

          end while next_page_link!=browser.url

        rescue Watir::Exception::UnknownObjectException => e
          p e.inspect
        rescue Watir::Wait::TimeoutError => e
          p 'done'
        end # external exception
      end

      result_array = result_array.uniq
      p result_array.size

      browser.close

      if ENV['RACK_ENV'] == 'production' || ENV['RAILS_ENV'] == 'production' || ENV['USER'] == 'deployer'
        headless.destroy
        logger.warn 'Headless destroyed'
      end

      logger.warn "------done parsing function method1 " + self.name + "------"
      return result_array
    rescue => e
      log_error :parse_mehtod_one, e
      return [[], [], []]
    end
  end

  def parsing_site_method2 #функция парсинга сайта
    begin
      logger.warn "------ start parsing function " + self.name + "------"

      css_page = self.css_pagination
      css_page = "no" if css_page.nil? || css_page.empty? #присвоение хоть чего нибудь, если значение не передано

      start_page = "http://" + self.name
      referer = start_page
      result_array = []
      site_urls_array = self.search_url.split(/[,]+/)

      site_urls_array.each do |site_url|
        #site_url = URI.escape site_url
        url_site_start = site_url
        previous_page = open(site_url, "Referer" => referer)
        cookies = previous_page.meta["set-cookie"] || ""
        cookies = "" if start_page == "http://technostil.by" #затычка для technostil.by

        begin
          logger.warn site_url
          last_page = site_url

          begin
            page = open(site_url, "Cookie" => cookies, "Referer" => referer)
          rescue => e
            page = open(URI.escape(site_url), "Cookie" => cookies, "Referer" => referer)
          end

          html = Nokogiri::HTML(page.read, nil, 'utf-8')

          name_array = html.css(self.css_item)
          price_array = html.css(self.css_price)

          if name_array.size != price_array.size #проверка соответствия кол-ва товаров и цен
            logger.warn "----------error---------"
            logger.warn "amount name:  #{name_array.size.to_s}, #{self.css_item}"
            logger.warn "amount price:  #{price_array.size.to_s}, #{self.css_price}"
            next
          end #проверка соответствия кол-ва товаров и цен
          name_array.each_with_index do |product, index|

            if product["href"].nil?
              str = start_page
            else
              str = check_link(product["href"], start_page)
            end

            logger.warn utf8(product.text)
            result_array << [utf8(product.text).strip, utf8(str), utf8(price_array[index].text)]


          end #цикл по списку товаров на странице

          if !html.at_css(css_page).nil? #проверка на наличие след. страницы
            site_url = html.at_css(css_page)["href"]
            site_url = check_link(site_url, url_site_start)
          end #проверка на наличие след. страницы

        end while !html.at_css(css_page).nil? && site_url != last_page #цикл пагинации

      end #цикл по списку адресов с товаром сайта

      return result_array

    rescue => e
      log_error :parse_method_two, e
      return [[], [], []]
    end
  end

  def utf8(str)
    str.encode!('utf-8', invalid: :replace, undef: :replace, replace: '')
    #file_contents.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    #file_contents.encode!('UTF-8', 'UTF-16')
  end

#функция парсинга сайта
  def update_urls(result_array)
    begin
      self.urls.destroy_all

      user_array = User.all
      site_groups=self.groups

      user_array.each do |user|
        result_groups = []
        site_groups.each do |group|
          if group.user_id == user.id
            result_groups << group
          end
        end

        items = []
        result_groups.each do |group|
          items += Item.joins(:group => :user).where(groups: {name: group.name}, users: {username: user.username}).readonly(false)
        end

        items = items.sort_by { |item| item.name.size }
        items = items.reverse

        result_urls = []
        start_page = "http://" + self.name
        result_urls = Url.joins(item: {group: :user}).where(items: {group_id: user.groups.map(&:id)})

        result_array.each do |item_array|
          url_str = item_array[1]
          price = item_array[2]
          price = price.to_f < items[0].group.settings.rate ? price.to_f*items[0].group.settings.rate : price.to_f

          if url_str != start_page #проверка на нормальность ссылки
            url = result_urls.where(url: url_str).first
          end


          if url.nil? || url_str == start_page
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
            #p "OK " + item.name
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
      end
      self.save
    rescue => e
      log_error(:update_urls, e)
    end

  end

  def log_error(name, e)
    logger.error "#{Time.now.strftime "%H:%M:%S %d/%m"}. Error #{self.name}: method #{name}\n  #{e.message}\n  #{e.backtrace[0..3].join("\n")}"
  end

  def find_item(text, price, items)
    begin
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

      #logger.warn 'Не найдено: ' + compressed_text
      return nil

    rescue => e
      log_error :find_item, e
    end
  end

  def price_fit?(item, price)
    begin
      standard_price = (item.urls & item.group.sites.where(standard: true).first.urls).first.price
      if (standard_price/price.to_f - 1).abs < 0.4
        true
      else
        false
      end
    rescue => e
      log_error :price_fit, e
    end
  end

  def update_url(price, url_str, item)
    begin
      url = Url.new
      url.site = self
      url.item = item
      url.url = url_str
      url.price = price.to_f < item.group.settings.rate ? price.to_f*item.group.settings.rate : price.to_f

      url.save

      allowed_error = url.item.group.settings.allowed_error
      allowed_error = allowed_error.include?('%') ? allowed_error.gsub('%', '').to_f/100 * url.price : allowed_error.to_f

      standard_price = url.item.get_standard_price

      url.check_for_violation(standard_price, allowed_error)
    rescue => e
      log_error :update_single_url, e
    end

  end

  def scrap_page(html, css_item, css_price)
    result_array = []
    items = html.css css_item
    prices = html.css css_price
    p items.size
    p prices.size
    if items.size == 0
      p 'page is not loaded'
      raise NotLoadedYetError, 'trying again'
    end
    items.to_a.each_index do |index|
      href = items[index]['href'].include?(self.name) ? items[index]['href'] : 'http://' + self.name + items[index]['href']
      result_array << [items[index].text, href, prices[index].text] unless prices[index].nil?
      p href
    end
    result_array
  end

  def self.spaces(x)
    str = x.to_i.to_s.reverse
    str.gsub!(/([0-9]{3})/, "\\1 ")
    return str.gsub(/,$/, '').reverse
  end

end