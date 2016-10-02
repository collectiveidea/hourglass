class TeamsController < ApplicationController
  include HasHarvest

  def index
    @teams = Team.active
  end

  def new
    @team = Team.new
    @harvest_projects = harvest_projects_list
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
    @harvest_projects = harvest_projects_list
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

  def harvest_projects_list
    harvest.projects.all.select {|p| p.active? }
  end

  def team_attributes
    params.require(:team).permit(
      :name,
      :hours,
      :project_id,
      assignments_attributes: [:id, :user_id, :hours, :_destroy]
    )
  end
end
