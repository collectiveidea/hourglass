class SendTimerReminders
  include Interactor
  include HasHarvest

  before do
    context.date ||= Date.current
  end

  def call
    User.all.each do |user|
      next if user.timer_reminder_sent_on.try(:today?)

      time_entries = harvest.time.all(context.date, user.harvest_id)
      Notifier.timer_reminder(user).deliver_now if time_entries.none?
      user.update!(timer_reminder_sent_on: context.date)
    end
  end
end
