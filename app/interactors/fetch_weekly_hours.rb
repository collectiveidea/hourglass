class FetchWeeklyHours
  include Interactor

  before do
    context.date ||= Date.current
    context.from ||= context.date.days_ago(6)
    context.range ||= context.from..context.date
  end

  def call
    context.range.each do |date|
      FetchDailyHours.call!(date: date)
    end
  end
end
