class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.decimal :ban_time
      t.datetime :last_updated
      t.decimal :allowed_error

      t.belongs_to :user

      t.timestamps
    end
  end
end
