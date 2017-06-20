class AddHoursToDays < ActiveRecord::Migration
  def up
    add_column :days, :hours, :jsonb, default: "{}", null: false
    add_index :days, :hours, using: :gin

    execute <<~SQL
      UPDATE days
      SET
        hours = jsonb_build_object(
          'client', client_hours,
          'internal', internal_hours
        )
      SQL
  end

  def down
    remove_column :days, :hours
  end
end
