class Row < ActiveRecord::Base
  belongs_to :site
  belongs_to :group
end
