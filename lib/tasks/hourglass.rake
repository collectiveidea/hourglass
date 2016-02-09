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
  task :report, [:date] => :environment do |_, args|
    date = args[:date] ? Date.parse(args[:date]) : Date.current.last_month
    puts GenerateReport.call!(date: date).output
  end
end
