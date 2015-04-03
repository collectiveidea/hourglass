class SendWeeklyReports
  include Interactor

  def call
    User.all.each do |user|
      Notifier.weekly_report(user).deliver_now
    end
  end
end
