class StatusboardsController < ApplicationController
  def show
    today, number_of_days = Date.current, ENV["STATUSBOARD_DAYS"].to_i
    date_range = (today - (number_of_days - 1).days)..today

    @team_days = TeamDay.for_date_range(date_range)
  end
end
