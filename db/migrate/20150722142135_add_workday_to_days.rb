class AddWorkdayToDays < ActiveRecord::Migration
  def change
    add_column :days, :workday, :boolean, default: false, null: false
  end
end
