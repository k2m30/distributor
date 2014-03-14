class Group < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :rows, dependent: :destroy
  has_one :settings, dependent: :destroy
  has_and_belongs_to_many :sites

  def get_standard_site
    Rails.cache.fetch([self, 'standard_site']){self.sites.where(standard: true).first}
  end

  def get_items
    Rails.cache.fetch([self, 'items']){self.items}
  end
end
