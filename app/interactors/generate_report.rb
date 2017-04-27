class GenerateReport
  include Interactor

  before do
    context.date ||= Date.current.last_month
    context.range ||= context.date.all_month

    context.output = [
      "Email",
      "Client Hours",
      "Internal Hours",
      "PTO Hours",
      "Total Hours",
      "Workdays",
      "Hours per Workday",
      "Timer Reminder Sent",
      "Timer Reminder %",
      "Tracked in Real Time",
      "Real Time %"
    ].to_csv
  end

  def call
    User.active.order(:email).each do |user|
      if (days = user.days.where(date: context.range).to_a).any?
        context.output << [
          user.email,
          days.sum(&:client_hours),
          days.sum(&:internal_hours),
          days.sum(&:pto_hours),
          days.sum(&:total_hours),
          days.count(&:workday?),
          (days.sum(&:total_hours) / days.count(&:workday?)).round(2),
          days.count(&:timer_reminder_sent?),
          (100.to_d * days.count(&:timer_reminder_sent?) / days.count(&:workday?)).round,
          days.count(&:tracked_in_real_time?),
          [(100.to_d * days.count(&:tracked_in_real_time?) / days.count(&:workday?)).round, 100].min
        ].to_csv
      elsif month = user.months.find_by(
        year: context.date.year,
        number: context.date.month
      )
        context.output << [
          user.email,
          month.client_hours,
          month.internal_hours,
          month.pto_hours,
          month.total_hours,
          month.workday_count,
          (month.total_hours / month.workday_count).round(2),
          month.timer_reminder_sent_count,
          (100.to_d * month.timer_reminder_sent_count / month.workday_count).round,
          month.tracked_in_real_time_count,
          [(100.to_d * month.tracked_in_real_time_count / month.workday_count).round, 100].min
        ].to_csv
      end
    end
  end
end
