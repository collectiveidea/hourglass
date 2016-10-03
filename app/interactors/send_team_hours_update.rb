class SendTeamHoursUpdate
  include Interactor
  include HasHarvest

  def call
    from = Date.this_week.first
    to = Date.this_week.last

    Team.active.each do |team|
      time_entries = harvest.reports.time_by_project(team.project_id, from, to, billable: true)
      Notifier.team_hours_update(team, time_entries).deliver_now
    end
  end
end
