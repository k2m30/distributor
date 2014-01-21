class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :urls, :url
    add_index :urls, :site_id
    add_index :urls, :item_id
    add_index :urls, :price
    add_index :sites, :name
    add_index :items, :name
  end
end
