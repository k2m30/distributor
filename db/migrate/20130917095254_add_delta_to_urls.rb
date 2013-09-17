class AddDeltaToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :delta, :decimal
  end
end
