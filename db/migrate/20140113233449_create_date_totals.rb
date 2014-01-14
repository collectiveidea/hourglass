class CreateDateTotals < ActiveRecord::Migration
  def change
    create_table :date_totals do |t|
      t.date :date
      t.decimal :billable_hours, precision: 5, scale: 2

      t.timestamps
    end
  end
end
