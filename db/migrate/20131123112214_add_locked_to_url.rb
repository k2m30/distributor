class AddLockedToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :locked, :boolean, default: false
  end
end
