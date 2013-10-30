require "spec_helper"

feature "Project Update" do
  let!(:project) {
    create(:project,
      name: "Project X",
      harvest_id: 1234,
      expected_weekly_hours: 123
    )
  }

  scenario "A user can update a project" do
    visit projects_path
    Dom::Project.first.update

    Dom::ProjectForm.update(
      name: "Project Y",
      harvest_id: 5678,
      expected_weekly_hours: 456
    )

    project.reload
    expect(project.name).to eq("Project Y")
    expect(project.harvest_id).to eq(5678)
    expect(project.expected_weekly_hours).to eq(456)
  end
end
