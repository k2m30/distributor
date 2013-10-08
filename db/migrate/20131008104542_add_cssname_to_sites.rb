class AddCssnameToSites < ActiveRecord::Migration
  def change
    add_column :sites, :css_name, :string
  end
end
