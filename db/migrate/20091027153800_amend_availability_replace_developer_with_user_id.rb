class AmendAvailabilityReplaceDeveloperWithUserId < ActiveRecord::Migration
  def self.up

    # This is a breaking change as there was no concept of users
    # All existing availabilities must go
    Availability.delete_all
    #Pairs.delete_all

    remove_column :availabilities, :developer
    remove_column :availabilities, :contact
    add_column :availabilities, :user_id, :integer
    add_column :users, :contact, :string
  end

  def self.down
    add_column  :availabilities, :developer, :string
    add_column  :availabilities, :contact, :string
    remove_column :availabilities, :user_id
    remove_column :users, :contact
  end
end
