json.graph do
  json.title "Time Tracking"
  json.datasequences @sequences do |sequence|
    json.title sequence[:title]
    json.datapoints sequence[:date_totals] do |date_total|
      json.partial! date_total, key: sequence[:key]
    end
  end
end
