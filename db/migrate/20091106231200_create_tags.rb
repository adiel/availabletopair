class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :tag, :null => false, :unique => true
      t.timestamps
    end

    create_table :availabilities_tags_links do |t|
      t.integer :availability_id, :null => false
      t.integer :tag_id,          :null => false
    end

    add_column :pairs, :tags, :string
  end

  def self.down
    drop_table :tags
    drop_table :availabilities_tags_links
    remove_column :pairs, :tags
  end
end
