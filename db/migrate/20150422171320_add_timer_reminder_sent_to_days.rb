class AddTimerReminderSentToDays < ActiveRecord::Migration
  def change
    add_column :days, :timer_reminder_sent, :boolean, default: false, null: false
  end
end
