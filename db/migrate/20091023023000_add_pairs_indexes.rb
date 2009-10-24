class AddPairsIndexes < ActiveRecord::Migration
  def self.up
    add_index :pairs, [:availability_id], {:name => "pairs_availability_id_index"}
  end

  def self.down
    remove_index :pairs, "pairs_availability_id_index"
  end
end
