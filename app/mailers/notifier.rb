class Notifier < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  default from: ENV["EMAIL_FROM"]

  def weekly_report(user)
    @user = user
    @client_hours = user.client_hours_last_week
    @internal_hours = user.internal_hours_last_week
    @total_hours = @client_hours + @internal_hours

    mail to: user.email
  end

  private

  def pluralize_hours(hours)
    pluralize(number_with_precision(hours, precision: 1), "hour")
  end

  helper_method :pluralize_hours
end
