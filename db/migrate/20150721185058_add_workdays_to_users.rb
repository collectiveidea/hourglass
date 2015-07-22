class AddWorkdaysToUsers < ActiveRecord::Migration
  def change
    add_column :users, :workdays, :string, array: true, default: %w(1 2 3 4 5), null: false
  end
end
