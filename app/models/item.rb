class Item < ActiveRecord::Base
  has_many :urls
  belongs_to :group

  accepts_nested_attributes_for :urls, allow_destroy: true
end
