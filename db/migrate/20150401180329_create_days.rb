class CreateDays < ActiveRecord::Migration
  def change
    create_table :days, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.date :date, null: false
      t.string :month_number, null: false
      t.string :week_number, null: false
      t.decimal :client_hours, default: 0, null: false, precision: 4, scale: 2
      t.decimal :internal_hours, default: 0, null: false, precision: 4, scale: 2
      t.timestamps null: false
    end

    add_index :days, :user_id
    add_index :days, :date
    add_index :days, :month_number
    add_index :days, :week_number
  end
end
