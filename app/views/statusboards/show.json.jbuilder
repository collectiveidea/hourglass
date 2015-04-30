json.graph do
  json.title "Time Tracking"
  json.total true
  json.type "bar"
  json.datasequences do
    json.child! do
      json.title "Client"
      json.color "green"
      json.datapoints @team_days do |team_day|
        json.title friendly_weekday(team_day.date)
        json.value team_day.client_hours.round
      end
    end
    json.child! do
      json.title "Internal"
      json.color "blue"
      json.datapoints @team_days do |team_day|
        json.title friendly_weekday(team_day.date)
        json.value team_day.internal_hours.round
      end
    end
    json.child! do
      json.title "PTO"
      json.color "red"
      json.datapoints @team_days do |team_day|
        json.title friendly_weekday(team_day.date)
        json.value team_day.pto_hours.round
      end
    end
  end
end
