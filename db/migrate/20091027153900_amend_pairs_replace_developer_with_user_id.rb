class AmendPairsReplaceDeveloperWithUserId < ActiveRecord::Migration
  def self.up
    remove_column :pairs, :developer
    remove_column :pairs, :contact
    add_column :pairs, :user_id, :integer
  end

  def self.down
    add_column  :pairs, :developer, :string
    add_column  :pairs, :contact, :string
    remove_column :pairs, :user_id
  end
end
