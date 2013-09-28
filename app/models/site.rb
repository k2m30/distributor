class Site < ActiveRecord::Base
  has_many :urls
  has_many :items, through: :urls
  has_and_belongs_to_many :groups
end
