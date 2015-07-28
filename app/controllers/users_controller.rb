class UsersController < ApplicationController
  def index
    @users = User.order(:name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_attributes)

    if @user.save
      redirect_to users_path
    else
      render :new
    end
  end

  def edit

  end

  def update

  end

  private

  def user_attributes
    params.require(:user).permit(
      :email,
      :harvest_id,
      :name,
      :slack_id,
      :time_zone,
      :zenefits_name,
      workdays: []
    )
  end
end
