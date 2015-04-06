module ApplicationHelper
  def friendly_weekday(date)
    if date == Date.current
      "Today"
    elsif date == Date.yesterday
      "Yesterday"
    else
      date.strftime("%A")
    end
  end
end
