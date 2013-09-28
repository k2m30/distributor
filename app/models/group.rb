class Group < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_and_belongs_to_many :sites
  accepts_nested_attributes_for :items
end
