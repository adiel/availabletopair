class AmendPairsAddStartAndEndTime < ActiveRecord::Migration
  def self.up
    add_column :pairs, :start_time, :datetime
    add_column :pairs, :end_time, :datetime
  end

  def self.down
    remove_column :availabilities, :start_time
    remove_column :availabilities, :end_time
  end
end
