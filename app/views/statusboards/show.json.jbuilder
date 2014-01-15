json.graph do
  json.title "Time Tracking"
  json.datasequences do
    json.child! do
      json.title "Billable"
      json.color "green"
      json.datapoints @date_totals do |date_total|
        json.title friendly_weekday(date_total.date)
        json.value date_total.billable_hours.to_f.round(2)
      end
    end
    json.child! do
      json.title "Unbillable"
      json.color "blue"
      json.datapoints @date_totals do |date_total|
        json.title friendly_weekday(date_total.date)
        json.value date_total.unbillable_hours.to_f.round(2)
      end
    end
  end
end
