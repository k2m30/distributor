class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name

      t.belongs_to :user
      t.timestamps
    end
    create_table :groups_sites do |t|
          t.belongs_to :site
          t.belongs_to :group
    end
  end
end
