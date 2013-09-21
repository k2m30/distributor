class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.decimal :ban_time, :default => 24 #hours in ban
      t.datetime :last_updated #prices updated
      t.decimal :allowed_error, :default => 2000 #price delta
      t.decimal :update_time, :default => 5 #minutes between updates

      t.belongs_to :user

      t.timestamps
    end
  end
end
