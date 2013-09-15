class AddStandardToSites < ActiveRecord::Migration
  def change
    add_column :sites, :standard, :boolean
  end
end
