feature "Teams" do
  scenario "A visitor can see the list of teams" do
    create(:team, name: "Test Team", hours: 80)
    create(:team, name: "News Team", hours: 40)

    visit teams_path

    dom_team_list = DOM::TeamList.find!
    expect(dom_team_list.count).to eq(2)

    dom_team_rows = dom_team_list.rows
    expect(dom_team_rows.count).to eq(2)
    expect(dom_team_rows[0].name).to eq("Test Team")
    expect(dom_team_rows[1].name).to eq("News Team")
  end

  scenario "A visitor can create a team" do
    visit teams_path

    dom_team_list = DOM::TeamList.find!
    dom_team_list.add

    dom_team_form = DOM::TeamForm.find!
    dom_team_form.set(
      name: "News Team",
      hours: 100,
    )
    dom_team_form.submit

    expect(current_path).to eq(teams_path)

    dom_team_rows = DOM::TeamRow.all
    expect(dom_team_rows.count).to eq(1)
    expect(dom_team_rows[0].name).to eq("News Team")

    news_team = Team.order(:created_at).last
    expect(news_team.name).to eq("News Team")
    expect(news_team.hours).to eq(100)
  end

  scenario "A visitor can update a team" do
    team = create(:team, name: "News Team", hours: 40)

    visit teams_path

    dom_team_row = DOM::TeamRow.find_by!(name: "News Team")
    dom_team_row.edit

    dom_team_form = DOM::TeamForm.find!
    dom_team_form.set(name: "Jump Team")
    dom_team_form.submit

    expect(current_path).to eq(teams_path)

    dom_team_rows = DOM::TeamRow.all
    expect(dom_team_rows.count).to eq(1)
    expect(dom_team_rows[0].name).to eq("Jump Team")

    expect(team.reload.name).to eq("Jump Team")
  end

  scenario "A visitor can add a user to the team"

  scenario "A visitor can archive a team" do
    create(:team, name: "News Team", hours: 40)

    visit teams_path

    dom_team_row = DOM::TeamRow.find_by!(name: "News Team")
    dom_team_row.archive

    expect(current_path).to eq(teams_path)
    expect(DOM::TeamRow.count).to eq(0)
  end

end
