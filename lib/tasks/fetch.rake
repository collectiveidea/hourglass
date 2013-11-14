desc "Fetch hours from Harvest"
task fetch: :environment do
  FetchWeek.perform
end
