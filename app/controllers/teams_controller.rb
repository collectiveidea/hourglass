class TeamsController < ApplicationController
  include HasHarvest

  def index
    @teams = Team.active.order(:name)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_attributes)

    if @team.save
      @team.update_project_name
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
      @team.update_project_name
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

  def harvest_projects
    @harvest_projects ||= begin
      clients = harvest.clients.all.group_by(&:id)
      harvest.projects.all.select(&:active?).group_by { |project|
        clients[project.client_id].first.name
      }.sort_by { |client_name, _| client_name }
    end
  end

  helper_method :harvest_projects

  def users
    @users ||= User.active.order(:email)
  end

  helper_method :users

  def team_attributes
    params.require(:team).permit(
      :name,
      :hours,
      :project_id,
      assignments_attributes: [:id, :user_id, :hours, :_destroy]
    )
  end
end
