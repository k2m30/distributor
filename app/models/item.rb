class Item < ActiveRecord::Base
  has_many :urls
  has_many :sites, through: :urls
  belongs_to :group, touch: true

  def get_group_name
    Rails.cache.fetch([self, 'group_name']){self.group.name}
  end

  def get_urls
    Rails.cache.fetch([self, 'urls']){self.urls}
  end

  def get_standard_price
    Rails.cache.fetch([self, 'standard_price']) do
      #rer
      url = (self.get_urls & self.group.get_standard_site.urls).first
      url.nil? ? nil : url.price
    end
  end

  def get_standard_url
    Rails.cache.fetch([self, 'standard_url']) do
      #urls1 = self.get_urls
      #urls2 = self.group.get_standard_site.get_urls

      (self.urls & self.group.get_standard_site.urls).first
    end
  end
end
