class AddRateToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :rate, :decimal
  end
end
