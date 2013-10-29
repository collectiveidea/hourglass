class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.integer :project_id
      t.date :date
      t.decimal :hours, precision: 5, scale: 2
      t.timestamps
    end

    add_index :days, [:project_id, :date], unique: true
    add_index :days, :date
  end
end
