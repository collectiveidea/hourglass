class SendTeamHoursUpdate
  include Interactor
  include HasHarvest

  def call
    week = context.week || Date.this_week
    from = week.first
    to = week.last

    Team.active.each do |team|
      time_entries = harvest.reports.time_by_project(team.project_id, from, to, billable: true)
      Notifier.team_hours_update(team, week, time_entries).deliver_now
    end
  end
end
