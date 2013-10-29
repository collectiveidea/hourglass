desc "Fetch hours from Harvest"
task fetch: :environment do
  FetchHours.perform
end
