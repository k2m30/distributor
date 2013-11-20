class Log < ActiveRecord::Base
  belongs_to :site


  def names
    Item.all
  end

end