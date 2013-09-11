class Url < ActiveRecord::Base
  belongs_to :site
  belongs_to :item
end
