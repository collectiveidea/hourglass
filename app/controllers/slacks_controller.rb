class SlacksController < ApplicationController
  def show
    @date_range = case params[:text]
                  when /today/
                    Date.current..Date.current
                  when /yesterday/
                    Date.yesterday..Date.yesterday
                  when /this week/
                    Date.current.all_week
                  when /last week/
                    1.week.ago.to_date.all_week
                  when /this month/
                    Date.current.all_month
                  when /last month/
                    1.month.ago.to_date.all_month
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
