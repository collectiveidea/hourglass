class SlacksController < ApplicationController
  def show
    @date_range = case params[:text]
                  when /today/
                    Date.current..Date.current
                  when /yesterday/
                    Date.yesterday..Date.yesterday
                  when /this week/
                    Date.this_week
                  when /last week/
                    Date.last_week
                  when /this month/
                    Date.this_month
                  when /last month/
                    Date.last_month
                  else nil
                  end

    if @date_range
      user = User.find_by!(slack_id: params[:user_id])

      @client_hours = user.client_hours_for_date_range(@date_range)
      @internal_hours = user.internal_hours_for_date_range(@date_range)
    else
      head :no_content
    end
  end
end
