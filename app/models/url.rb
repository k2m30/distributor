# encoding: UTF-8
require 'open-uri'
require 'nokogiri'

class Url < ActiveRecord::Base
  belongs_to :site #, counter_cache: true
  belongs_to :item

  def check_for_violation(standard_price, allowed_error)

    if !standard_price.nil? && (standard_price > 0) && !allowed_error.nil? && !self.price.nil? && (self.price > 0)
      self.violator = self.price < (standard_price - allowed_error) ? true : false
      if ((standard_price - self.price)/standard_price).abs > 0.3
        log = Log.new
        log.site = self.site
        log.log_type = 'Standard price = ' + standard_price.to_s
        log.price_found = self.price
        log.name_found = self.item.name
        log.message = self.item.name + ', ' + self.url
        log.save
      end
    else
      self.violator = false
    end
    self.save
  end

  def set_violator(val=true)
    self.violator=val
    self.save
  end

end
