class CreatePairs < ActiveRecord::Migration
  def self.up
    create_table :pairs do |t|
      t.integer :availability_id
      t.integer :available_pair_id
      t.timestamps
    end
  end

  def self.down
    drop_table :pairs
  end
end
