# encoding: UTF-8
require 'open-uri'
require "nokogiri"

class Url < ActiveRecord::Base
  belongs_to :site
  belongs_to :item
  has_many :logs

  def update_price(css, regexp, rate)
    begin
      css_content = nil
      log = Log.new
      log.url = self

      uri = URI.parse(self.url)
      logger.error uri.to_s
      page = open(uri, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.57 Safari/537.36 OPR/16.0.1196.73", "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Cache-Control" => "max-age=0")
      html = Nokogiri::HTML page
      css_content = html.at_css(css)
      css_content = css_content.content
      page_price = css_content.gsub(/\u00a0|\s/, "")
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
      if !page_price.nil? && !page_price.empty?
        log.log_type = "OK"
        log.ok = true
        log.ok_all = true
      else
        log.log_type = "Wrong address"
        log.ok = false
        log.ok_all = false
      end
      log.price_found = (css_content.nil? || css_content.empty?) ? self.url : css_content
      log.save
    rescue Exception => e
      self.price = -1
      self.violator = false
      self.save
      self.site.touch
      log = Log.new
      log.url = self
      log.log_type = "#{$!}"
      log.price_found = (css_content.nil? || css_content.empty?) ? self.url : css_content
      log.ok = false

      log.save
      ##logger.error(e.inspect)
    end
  end

  def check_for_violation(standard_price, allowed_error)
    self.violator = (self.price < (standard_price - allowed_error) && self.price > 0) ? true : false

    if (self.price > 0) && (((standard_price - self.price)/standard_price).abs > 0.3) && standard_price > 0
      log = Log.new
      log.url = self
      log.log_type = "Standard price = " + standard_price.to_s + ". This site price = " + self.price.to_s
      log.price_found = self.price
      log.save
    end

    if self.changed?
      self.save
      self.touch
    end
  end
end
