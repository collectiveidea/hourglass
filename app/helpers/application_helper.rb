module ApplicationHelper
  def friendly_weekday(date)
    if date == Date.current
      "Today"
    elsif date == Date.current - 1
      "Yesterday"
    else
      date.strftime('%A')
    end
  end
end
