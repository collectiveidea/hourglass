namespace :hourglass do
  desc "Fetch hours for today from Harvest for every user"
  task :fetch_daily_hours => :environment do
    FetchDailyHours.call
  end

  desc "Send weekly report emails to every user"
  task :send_weekly_reports => :environment do
    SendWeeklyReports.call if Date.current.monday?
  end

  desc "Roll up days from two months ago for every user"
  task :roll_up_month => :environment do
    Month.roll_up if Date.current.mday == 1
  end
end
