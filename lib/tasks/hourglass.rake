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
    SendWeeklyReports.call! if Date.current.monday? # Mondays
  end

  desc "Roll up days from two months ago for every user"
  task :roll_up_month => :environment do
    Month.roll_up if Date.current.mday == 1 # First of every month
  end

  desc "Send reminder emails to users who haven't started timers yet today"
  task :send_timer_reminders => :environment do
    SendTimerReminders.call! if Date.current.cwday < 6 # Weekdays
  end
end
