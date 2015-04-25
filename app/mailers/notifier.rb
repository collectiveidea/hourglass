class Notifier < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  default from: ENV["EMAIL_FROM"]

  def weekly_report(user)
    last_week = 1.week.ago.to_date.all_week

    @user = user
    @client_hours = user.client_hours_for_date_range(last_week)
    @internal_hours = user.internal_hours_for_date_range(last_week)
    @total_hours = @client_hours + @internal_hours

    @expected_client_hours = ENV["EXPECTED_WEEKLY_CLIENT_HOURS"].to_d
    @expected_internal_hours = ENV["EXPECTED_WEEKLY_INTERNAL_HOURS"].to_d

    mail to: user.email
  end

  def timer_reminder(user)
    @user = user

    mail to: user.email
  end

  private

  def pluralize_hours(hours)
    pluralize(number_with_precision(hours, precision: 1), "hour")
  end

  helper_method :pluralize_hours
end
