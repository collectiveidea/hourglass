class AddTrackedInRealTimeToDays < ActiveRecord::Migration
  def change
    add_column :days, :tracked_in_real_time, :boolean, default: false, null: false
  end
end
