class SlacksController < ApplicationController
  def show
    @date_range = case params[:text]
                  when /today/
                    today = Date.current
                    today..today
                  when /yesterday/
                    yesterday = Date.yesterday
                    yesterday..yesterday
                  when /this week/
                    today = Date.current
                    today.monday..today.sunday
                  when /last week/
                    a_week_ago = 1.week.ago.to_date
                    a_week_ago.monday..a_week_ago.sunday
                  when /this month/
                    today = Date.current
                    today.beginning_of_month..today.end_of_month
                  when /last month/
                    a_month_ago = 1.month.ago.to_date
                    a_month_ago.beginning_of_month..a_month_ago.end_of_month
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
