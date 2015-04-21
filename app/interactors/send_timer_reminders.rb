class SendTimerReminders
  include Interactor

  def call
    User.for_timer_reminder.each do |user|
      Notifier.timer_reminder(user).deliver_now
      user.timer_reminder_sent!
    end
  end
end
