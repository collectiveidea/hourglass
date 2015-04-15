class AddSlackIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slack_id, :string
    add_index :users, :slack_id, unique: true
  end
end
