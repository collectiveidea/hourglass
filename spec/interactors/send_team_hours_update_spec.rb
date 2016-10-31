describe SendTeamHoursUpdate do
  include ApplicationHelper

  it "sends an email to all team members of the current hours for the week" do
    team = create(:team, name: "Test Team", hours: 20, project_name: "Test Project")
    user_1 = create(:user, name: "Jason", email: "jason@test.com")
    user_2 = create(:user, name: "Chris", email: "chris@test.com")
    user_3 = create(:user, email: "user3@test.com")

    team.assignments.create(user: user_1, hours: 10)
    team.assignments.create(user: user_2, hours: 10)

    harvest = double(Harvest::HardyClient)
    harvest_reports = double(Harvest::API::Reports)

    allow(Harvest).to receive(:hardy_client).with(
      subdomain: ENV["HARVEST_SUBDOMAIN"],
      username: ENV["HARVEST_USERNAME"],
      password: ENV["HARVEST_PASSWORD"]
    ) { harvest }

    allow(harvest).to receive(:reports).with(no_args) { harvest_reports }

    time_range = Date.last_week

    expect(harvest_reports).to receive(:time_by_project).with(
      team.project_id, time_range.first, time_range.last, billable: true
    ) {
      [
        create(:harvest_time_entry, :client, hours: 1.0, user_id: user_1.harvest_id.to_i),
        create(:harvest_time_entry, :client, hours: 4.0, user_id: user_2.harvest_id.to_i),
        create(:harvest_time_entry, :client, hours: 12.0),
      ]
    }

    SendTeamHoursUpdate.call(week: time_range)

    open_last_email_for(user_1.email)
    expect(current_email).to have_subject(I18n.t("notifier.team_reminder.subject", team_name: "Test Team"))

    open_last_email_for(user_2.email)
    expect(current_email).to have_subject(I18n.t("notifier.team_reminder.subject", team_name: "Test Team"))

    expect(current_email).to have_body_text("20 budgeted hours")

    expect(current_email).to have_body_text(friendly_date_range(time_range))

    # Don't include details of users who have hours on the project
    # that aren't members of the team
    expect(current_email).to_not have_body_text("12")
    expect(current_email).to_not have_body_text(user_3.email)
  end

end
