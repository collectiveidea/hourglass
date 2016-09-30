class TeamsController < ApplicationController

  def index
    @teams = Team.active
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_attributes)

    if @team.save
      redirect_to teams_path
    else
      render :new
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])

    if @team.update(team_attributes)
      redirect_to teams_path
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find(params[:id])

    @team.archive

    redirect_to teams_path
  end

  private

  def team_attributes
    params.require(:team).permit(
      :name,
      :hours,
      assignments_attributes: [:id, :user_id, :hours, :_destroy]
    )
  end
end
