require "spec_helper"

feature "Project Removal" do
  let!(:project) { create(:project) }

  scenario "A user can update a project" do
    visit projects_path

    expect {
      Dom::Project.first.remove
    }.to change {
      Project.count
    }.from(1).to(0)
  end
end
