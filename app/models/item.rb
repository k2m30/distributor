class Item < ActiveRecord::Base
  has_many :urls
  has_many :sites, through: :urls
  belongs_to :group

  accepts_nested_attributes_for :urls, allow_destroy: true
end
