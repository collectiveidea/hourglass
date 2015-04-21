class SendTimerReminders
  include Interactor
  include HasHarvest

  before do
    context.date ||= Date.current
  end

  def call
    User.all.each do |user|
      time_entries = harvest.time.all(context.date, user.harvest_id)

      Notifier.timer_reminder(user).deliver_now if time_entries.none?
    end
  end
end
