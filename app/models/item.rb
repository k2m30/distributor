class Item < ActiveRecord::Base
  include PgSearch

  has_many :urls
  has_many :sites, through: :urls
  belongs_to :group

  pg_search_scope :item_search, against: [:name],
                  :associated_against => {
                      :sites => [:name],
                      :group => :name
                  }


  def get_group_name
    Rails.cache.fetch([self, 'group_name']) { self.group.name }
  end
  def get_name
    Rails.cache.fetch([self, 'name']) { self.name }
  end

  def get_urls
    Rails.cache.fetch([self, 'urls']) { self.urls }
  end

  def get_standard_price
    #Rails.cache.fetch([self, 'standard_price']) do
    #rer
    if self.standard_price.nil?
      url = (self.get_urls & self.group.get_standard_site.urls).first
      self.standard_price = url.nil? ? nil : url.price
      self.save
    end
    self.standard_price
  end

  def get_standard_url
    Rails.cache.fetch([self, 'standard_url']) do
      #urls1 = self.get_urls
      #urls2 = self.group.get_standard_site.get_urls

      (self.urls & self.group.get_standard_site.urls).first
    end
  end
end
