class AddViolatorAndEmailAndCompanyNameToSites < ActiveRecord::Migration
  def change
    add_column :sites, :violator, :boolean
    add_column :sites, :email, :string
    add_column :sites, :company_name, :string
    add_column :sites, :out_of_ban_time, :datetime
  end
end
