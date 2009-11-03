class AmendPairsAddSuggested < ActiveRecord::Migration
  def self.up
    add_column :pairs, :suggested, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :pairs, :suggested
  end
end
