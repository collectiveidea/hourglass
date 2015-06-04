class SlacksController < ApplicationController
  def show
    text = params[:text].squish.downcase
    date = case text
           when "today"
             Date.current
           when /(yester|mon|tues|wednes|thurs|fri)day/
             Date.send(text)
           when /(this|last) (week|month)/
             Date.send(text.tr(" ", "_"))
           else nil
           end

    @date_range = date.is_a?(Date) ? date..date : date

    if @date_range
      user = User.find_by!(slack_id: params[:user_id])

      @client_hours = user.client_hours_for_date_range(@date_range)
      @internal_hours = user.internal_hours_for_date_range(@date_range)
      @total_hours = @client_hours + @internal_hours
    else
      render :help, status: :bad_request
    end
  end
end
