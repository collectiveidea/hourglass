namespace :hourglass do
  desc "Fetch hours for today from Harvest for every user"
  task :fetch_daily_hours => :environment do
    FetchDailyHours.call!
  end

  desc "Fetch hours for this week from Harvest for every user"
  task :fetch_weekly_hours => :environment do
    FetchWeeklyHours.call!
  end

  desc "Send weekly report emails to every user"
  task :send_weekly_reports => :environment do
    # Mondays
    if Date.current.monday?
      SendWeeklyReports.call!
    end
  end

  desc "Roll up days from two months ago for every user"
  task :roll_up_month => :environment do
    # First of every month
    if Date.current.mday == 1
      Month.roll_up
    end
  end

  desc "Send reminder emails to users who haven't started timers yet today"
  task :send_timer_reminders => :environment do
    # Workdays on or after 10am in the user's time zone
    User.time_zones.each do |time_zone|
      if Time.current.in_time_zone(time_zone).hour >= 10
        SendTimerReminders.call!(time_zone: time_zone)
      end
    end
  end

  desc "Sync PTO from the Zenefits calendar"
  task :sync_pto => :environment do
    SyncPTO.call!
  end

  desc "Generate a CSV time tracking report for a given month"
  task :monthly_report, [:date] => :environment do |_, args|
    Rails.logger.silence do
      date = args[:date] ? Date.parse(args[:date]) : Date.current.last_month
      puts GenerateReport.call!(range: date.all_month).output
    end
  end

  desc "Generate a CSV time tracking report for a given week"
  task :weekly_report, [:date] => :environment do |_, args|
    Rails.logger.silence do
      date = args[:date] ? Date.parse(args[:date]) : Date.current.last_week
      puts GenerateReport.call!(range: date.all_week).output
    end
  end

  desc "Send report on current weekly team hours usage"
  task :team_hours_update => :environment do
    if Date.current.wednesday? || Date.current.friday?
      SendTeamHoursUpdate.call!(week: Date.this_week)
    end
  end

  desc "Send report on last week's team hours usage"
  task :last_week_team_hours => :environment do
    if Date.current.monday?
      SendTeamHoursUpdate.call!(week: Date.last_week)
    end
  end
end
