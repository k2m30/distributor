class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url
      t.decimal :price
      t.belongs_to :site
      t.belongs_to :item

      t.timestamps
    end
  end
end
