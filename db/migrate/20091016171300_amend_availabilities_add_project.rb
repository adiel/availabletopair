class AmendAvailabilitiesAddProject < ActiveRecord::Migration
  def self.up
    add_column :availabilities, :project, :string
  end

  def self.down
    remove_column :availabilities, :project
  end
end
