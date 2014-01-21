class AddStandardPriceToItems < ActiveRecord::Migration
  def change
    add_column :items, :standard_price, :decimal
  end
end
