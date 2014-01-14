class StatusboardsController < ApplicationController
  def show
    @date_totals = DateTotal.where(date: Date.current-10..Date.current).order('date')
  end
end
