class AddAvailabilitiesIndexes < ActiveRecord::Migration
  def self.up
    add_index :availabilities, [:developer], {:name => "availabilities_name_index"}
    add_index :availabilities, [:developer,:start_time,:end_time], {:name => "availabilities_pair_search_index"}
  end

  def self.down
    remove_index :availabilities, "availabilities_name_index"
    remove_index :availabilities, "availabilities_pair_search_index"
  end
end
