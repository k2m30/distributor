class AddDeltaToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :delta, :decimal    #between url.price and standard price (%)
  end
end
