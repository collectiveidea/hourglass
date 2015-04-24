class AddTimerReminderSentOnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timer_reminder_sent_on, :date
  end
end
