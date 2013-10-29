class RenameGuaranteedWeeklyHours < ActiveRecord::Migration
  def change
    rename_column :projects, :guaranteed_weekly_hours, :expected_weekly_hours
  end
end
