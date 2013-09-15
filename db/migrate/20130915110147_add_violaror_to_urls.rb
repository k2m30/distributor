class AddViolarorToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :violator, :boolean
  end
end
