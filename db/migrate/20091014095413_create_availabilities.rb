class CreateAvailabilities < ActiveRecord::Migration
  def self.up
    create_table :availabilities do |t|
      t.string :developer
      t.datetime :start_time
      t.datetime :end_time
      t.string :contact

      t.timestamps
    end
  end

  def self.down
    drop_table :availabilities
  end
end
