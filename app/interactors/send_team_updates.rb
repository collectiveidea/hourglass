class SendTeamUpdates
  include Interactor
  include HasHarvest

  def call
    Team.active.each do |team|
      from = Date.this_week.first
      to = Date.this_week.last

      time_entries = harvest.reports.time_by_project(team.project_id, from, to, billable: true)

      team.users.each do |user|
        Notifier.team_reminder(user, team, time_entries).deliver_now
      end
    end
  end
end
