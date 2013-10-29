class RenameGuaranteedHours < ActiveRecord::Migration
  def change
    rename_column :projects, :guaranteed_hours, :guaranteed_weekly_hours
  end
end
