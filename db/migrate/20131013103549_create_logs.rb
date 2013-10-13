class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.text :message
      t.string :price_found
      t.string :name_found
      t.string :log_type
      t.boolean :ok
      t.boolean :ok_all
      t.belongs_to :url

      t.timestamps
    end
  end
end
