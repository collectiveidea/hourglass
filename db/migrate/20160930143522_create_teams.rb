class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.integer :hours, null: false
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
