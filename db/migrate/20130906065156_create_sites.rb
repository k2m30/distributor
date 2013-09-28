class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :css
      t.string :xpath
      t.string :regexp
      t.string :one_k_path
      t.string :onliner_path
      t.string :initial_request
      t.timestamps
    end
  end
end
