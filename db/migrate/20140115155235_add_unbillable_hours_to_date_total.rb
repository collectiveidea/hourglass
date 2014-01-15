class AddUnbillableHoursToDateTotal < ActiveRecord::Migration
  def change
    change_table :date_totals do |t|
      t.decimal :unbillable_hours, precision: 5, scale: 2
    end
  end
end
