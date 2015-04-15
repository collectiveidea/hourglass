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

  def friendly_date_range(date_range)
    first, last = date_range.first, date_range.last

    parts = [
      first.strftime("%B"),
      first.strftime("%-d"),
      last.strftime("%B"),
      last.strftime("%-d")
    ].uniq

    parts.insert(2, "–") if parts.size > 2
    parts.join(" ")
  end
end
