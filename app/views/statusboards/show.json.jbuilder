json.title "Billable Hours"
json.refreshEveryNSeconds 3600
json.datapoints @date_totals do |date_total|
  json.partial! date_total
end
