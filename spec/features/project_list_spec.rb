require "spec_helper"

feature "Project List" do
  scenario "A user can see a list of projects" do
    projects = create_list(:project, 3)

    visit projects_path

    dom_projects = Dom::Project.all
    expect(dom_projects.count).to eq(3)

    projects.each_with_index do |project, i|
      expect(dom_projects[i].name).to eq(project.name)
      expect(dom_projects[i].harvest_id).to eq(project.harvest_id)
      expect(dom_projects[i].guaranteed_hours).to eq(project.guaranteed_hours)
    end
  end
end
