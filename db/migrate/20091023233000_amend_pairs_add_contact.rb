class AmendPairsAddContact < ActiveRecord::Migration
  def self.up
    add_column :pairs, :contact, :string
  end

  def self.down
    remove_column :availabilities, :contact
  end
end
