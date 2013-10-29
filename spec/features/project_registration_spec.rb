require "spec_helper"

feature "Project Registration" do
  scenario "A user can register a project" do
    visit root_path
    click_link "Add Project"

    expect {
      fill_in "Name", with: "Project X"
      fill_in "Harvest ID", with: "12345"
      fill_in "Guaranteed Weekly Hours", with: "123"
      click_button "Save"
    }.to change {
      Project.count
    }.from(0).to(1)

    project = Project.last
    expect(project.name).to eq("Project X")
    expect(project.harvest_id).to eq(12345)
    expect(project.guaranteed_weekly_hours).to eq(123)
  end
end
