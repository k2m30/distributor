# encoding: UTF-8
require 'open-uri'
require "nokogiri"

class Url < ActiveRecord::Base
  belongs_to :site
  belongs_to :item
  has_many :logs

  def update_price(css, regexp, rate)
    begin
      uri = URI.parse(self.url)
#      puts "---"
      logger.error uri.to_s
      page = open(uri, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 OPR/16.0.1196.73", "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Cache-Control" => "max-age=0")
      html = Nokogiri::HTML page
      page_price = html.at_css(css).content.gsub(/\u00a0|\s/, "")
      if  page_price.scan(/\d\.\d{3}/).count > 0
        page_price = page_price.gsub(".", "") #костыль специально для kosilka.by
      end
      logger.error page_price
      r = Regexp.new(regexp)
      page_price = page_price.mb_chars.downcase.to_s[r]
      self.price = (page_price.to_f<rate) ? rate*page_price.to_f : page_price
      logger.error self.price
      self.save
      self.site.touch

      #log.log_type = "OK"
      #log.price_found = page_price
      #log.ok = true
      #log.ok_all = true
      #log.save
    rescue
      self.price = -1
      self.save
      logger.error("-----" + self.url + ' '+ rate)
      logger.error("#{$!}")
      self.site.touch
    #  log = Log.new
    #  log.url = self
    #  log.text = "#{$!}"
    #  log.save
    ##logger.error(e.inspect)
    end
  end

  def check_for_violation(standard_price, allowed_error)
    self.violator = (self.price < (standard_price - allowed_error) && self.price > 0) ? true : false
    if self.changed?
      self.save
      self.touch
    end
  end
end
