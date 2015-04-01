class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :number, null: false
      t.decimal :client_hours, default: 0, null: false, precision: 4, scale: 2
      t.decimal :internal_hours, default: 0, null: false, precision: 4, scale: 2
      t.timestamps null: false
    end

    add_index :months, :user_id
    add_index :months, :number
  end
end
