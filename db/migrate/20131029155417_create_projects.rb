class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :harvest_id
      t.integer :guaranteed_hours
      t.timestamps
    end
  end
end
