class Notifier < ActionMailer::Base
  default from: ENV["EMAIL_FROM"]

  def weekly_report(user)
    @user = user
    @client_hours = user.client_hours_last_week
    @internal_hours = user.internal_hours_last_week
    @total_hours = @client_hours + @internal_hours

    mail to: user.email
  end
end
