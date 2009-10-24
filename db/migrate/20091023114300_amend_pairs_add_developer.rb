class AmendPairsAddDeveloper < ActiveRecord::Migration
  def self.up
    add_column :pairs, :developer, :string
  end

  def self.down
    remove_column :availabilities, :developer
  end
end
