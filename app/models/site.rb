class Site < ActiveRecord::Base
  has_many :urls
  has_many :items, through: :urls
end
