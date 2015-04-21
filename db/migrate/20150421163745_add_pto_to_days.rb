class AddPTOToDays < ActiveRecord::Migration
  def change
    add_column :days, :pto, :boolean, default: false, null: false
  end
end
