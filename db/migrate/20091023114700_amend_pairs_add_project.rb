class AmendPairsAddProject < ActiveRecord::Migration
  def self.up
    add_column :pairs, :project, :string
  end

  def self.down
    remove_column :availabilities, :project
  end
end
