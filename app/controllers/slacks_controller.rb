class SlacksController < ApplicationController
  def show
    @date_range = case params[:text]
                  when /today/
                    today = Date.current
                    today..today
                  when /this week/
                    today = Date.current
                    today.monday..today.sunday
                  when /this month/
                    today = Date.current
                    today.beginning_of_month..today.end_of_month
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
