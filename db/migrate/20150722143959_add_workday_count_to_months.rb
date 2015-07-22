class AddWorkdayCountToMonths < ActiveRecord::Migration
  def change
    add_column :months, :workday_count, :integer, default: 0, null: false
  end
end
