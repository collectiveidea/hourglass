json.graph do
  json.title "Time Tracking"
  json.datasequences @sequences do |sequence|
    json.partial! sequence
  end
end
