class Notifier < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  include ApplicationHelper
  helper_method :friendly_date_range

  default from: ENV["EMAIL_FROM"]

  def weekly_report(user)
    last_week = Date.last_week

    @user = user
    @client_hours = user.client_hours_for_date_range(last_week)
    @internal_hours = user.internal_hours_for_date_range(last_week)
    @pto_hours = user.pto_hours_for_date_range(last_week)
    @total_hours = @client_hours + @internal_hours + @pto_hours

    @expected_client_hours = ENV["EXPECTED_WEEKLY_CLIENT_HOURS"].to_d
    @expected_internal_hours = ENV["EXPECTED_WEEKLY_INTERNAL_HOURS"].to_d
    @expected_total_hours = @expected_client_hours + @expected_internal_hours

    pto_multiplier = 1.to_d - @pto_hours / @expected_total_hours
    @expected_client_hours *= pto_multiplier
    @expected_internal_hours *= pto_multiplier

    @missing_hours = [@expected_total_hours - @total_hours, 0].max

    mail to: user.email
  end

  def timer_reminder(user)
    @user = user

    mail to: user.email
  end

  def team_hours_update(team, project_hours)
    @team = team

    @hours_by_user = @team.assignments.includes(:user).inject({}) do |memo, assignment|
      memo[assignment.user.harvest_id.to_i] = {
        user_email: assignment.user.email,
        user_hours: 0,
        expected_hours: assignment.hours,
      }
      memo
    end

    @billed_hours = 0
    project_hours.each do |time_entry|
      details = @hours_by_user[time_entry.user_id]
      if details
        details[:user_hours] += time_entry.hours
        @billed_hours += time_entry.hours
      end
    end

    mail to: team.users.map(&:email), subject: I18n.t("notifier.team_reminder.subject", team_name: @team.name)
  end

  private

  def pluralize_hours(hours)
    pluralize(number_with_precision(hours, precision: 1), "hour")
  end

  helper_method :pluralize_hours
end
