require "spec_helper"

describe "Projects" do
  describe "GET /projects.json" do
    it "returns projects with this week's hours" do
      monday = Date.current.beginning_of_week
      sunday = monday + 6.days

      project1 = create(:project, guaranteed_weekly_hours: 20)
      project2 = create(:project, guaranteed_weekly_hours: 10)
      create(:day, project: project1, date: monday, hours: 1)
      create(:day, project: project1, date: sunday, hours: 2)
      create(:day, project: project2, date: monday, hours: 4)
      create(:day, project: project2, date: sunday, hours: 8)

      get "projects.json"

      expect(response.status).to eq(200)

      json = JSON.load(response.body)
      expect(json).to eq(
        "projects" => [
          {
            "id" => project1.id,
            "harvest_id" => project1.harvest_id,
            "guaranteed_weekly_hours" => 20,
            "current_weekly_hours" => 3.0,
            "weekly_hours_met" => false
          },
          {
            "id" => project2.id,
            "harvest_id" => project2.harvest_id,
            "guaranteed_weekly_hours" => 10,
            "current_weekly_hours" => 12.0,
            "weekly_hours_met" => true
          }
        ]
      )
    end
  end
end
