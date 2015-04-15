class SlacksController < ApplicationController
  def show
    today = Date.current

    @date_range = case params[:text]
                  when /day/ then today..today
                  when /week/ then today.monday..today.sunday
                  when /month/ then today.beginning_of_month..today.end_of_month
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
