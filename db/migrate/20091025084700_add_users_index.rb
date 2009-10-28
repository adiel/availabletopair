class AddUsersIndex < ActiveRecord::Migration
  def self.up
    #add_index :users, :openid_identifier, "users_openid_identifier"
  end

  def self.down
    #remove_index :users, "users_openid_identifier"
  end
end
