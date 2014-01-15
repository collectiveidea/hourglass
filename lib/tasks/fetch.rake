namespace :fetch do
  desc "Fetch the week's hours from Harvest"
  task week: :environment do
    FetchWeek.perform
  end

  desc "Fetch today's totals from Harvest"
  task today: :environment do
    FetchTotals.perform(Date.current)
  end
end
