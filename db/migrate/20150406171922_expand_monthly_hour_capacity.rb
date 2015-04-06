class ExpandMonthlyHourCapacity < ActiveRecord::Migration
  def up
    change_column :months, :client_hours, :decimal, precision: 5, scale: 2
    change_column :months, :internal_hours, :decimal, precision: 5, scale: 2
  end

  def down
    change_column :months, :client_hours, :decimal, precision: 4, scale: 2
    change_column :months, :internal_hours, :decimal, precision: 4, scale: 2
  end
end
