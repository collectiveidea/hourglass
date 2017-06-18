class AddTagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tags, :text, array: true, default: []
    add_index :users, :tags, using: "gin"
  end
end
