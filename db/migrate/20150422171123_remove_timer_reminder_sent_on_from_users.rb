class RemoveTimerReminderSentOnFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :timer_reminder_sent_on
  end

  def down
    add_column :users, :timer_reminder_sent_on, :date
  end
end
