json.title sequence.title
json.datapoints sequence.date_totals do |date_total|
  json.title friendly_weekday(date_total.date)
  json.value date_total.attributes[sequence.key.to_s].to_f.round(2)
end