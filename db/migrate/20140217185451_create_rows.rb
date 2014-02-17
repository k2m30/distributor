class CreateRows < ActiveRecord::Migration
  def change
    create_table :rows do |t|
      t.text :html
      t.belongs_to :site
      t.belongs_to :group
    end
  end
end
