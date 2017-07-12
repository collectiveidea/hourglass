class AddSortOrderToResponsibilities < ActiveRecord::Migration
  def change
    add_column :responsibilities, :sort_order, :integer
    add_index :responsibilities, :sort_order
  end
end
