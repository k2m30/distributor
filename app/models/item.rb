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
      standard_url = self.get_urls & self.group.get_standard_site.get_urls
      if standard_url.nil? || standard_url.empty?
        nil
      else
        standard_url.first.price
      end
    end
  end

  def get_standard_url
    Rails.cache.fetch([self, 'standard_url']) do
      standard_url = self.get_urls & self.group.get_standard_site.get_urls
      if standard_url.nil? || standard_url.empty?
        nil
      else
        standard_url.first.url
      end
    end
  end
end
