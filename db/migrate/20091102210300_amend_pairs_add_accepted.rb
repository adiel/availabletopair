class AmendPairsAddAccepted < ActiveRecord::Migration
  def self.up
    add_column :pairs, :accepted, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :pairs, :accepted
  end
end
