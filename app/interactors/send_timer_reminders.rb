class SendTimerReminders
  include Interactor

  before do
    context.date ||= Date.current
  end

  def call
    User.where(time_zone: context.time_zone).for_timer_reminder(date: context.date).each do |user|
      Notifier.timer_reminder(user).deliver_now
      user.timer_reminder_sent!(date: context.date)
    end
  end
end
