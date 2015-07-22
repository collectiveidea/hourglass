class SendWeeklyReports
  include Interactor

  def call
    User.active.each do |user|
      Notifier.weekly_report(user).deliver_now
    end
  end
end
