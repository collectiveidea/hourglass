class AddActiveToResponsibilities < ActiveRecord::Migration
  def change
    add_column :responsibilities, :active, :boolean, default: true, null: false
    add_index :responsibilities, :active
  end
end
