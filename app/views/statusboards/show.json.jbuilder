json.graph do
  json.title "Time Tracking"
  json.datasequences [@date_totals] do |sequence|
    json.title "Billable Hours"
    json.refreshEveryNSeconds 3600
    json.datapoints sequence do |date_total|
      json.partial! date_total
    end
  end
end
