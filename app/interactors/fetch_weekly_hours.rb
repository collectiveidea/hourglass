class FetchWeeklyHours
  include Interactor

  before do
    context.date ||= Date.current
    context.from ||= context.date.monday
    context.to ||= context.date.sunday
    context.range ||= context.from..context.to
  end

  def call
    context.range.each do |date|
      FetchDailyHours.call!(date: date)
    end
  end
end
