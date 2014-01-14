class StatusboardsController < ApplicationController
  def show
    days = ENV['STATUSBOARD_DAYS'] || 10
    @date_totals = DateTotal.where(date: Date.current-days-1..Date.current).order('date')
  end
end
