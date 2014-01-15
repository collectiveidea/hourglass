class StatusboardsController < ApplicationController
  def show
    days = ENV['STATUSBOARD_DAYS'] || 10
    # we need an integer, subtract one since we'll use today
    days = days.to_i - 1 
    date_totals = DateTotal.where(date: Date.current-days..Date.current).order('date')
    @sequences = [
      Sequence.new(title: "Billable Hours",  key: :billable_hours, date_totals: date_totals),
      Sequence.new(title: "Unbillable Hours", key: :unbillable_hours, date_totals: date_totals),
    ]
  end
end
