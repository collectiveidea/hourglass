require "spec_helper"

describe "Projects" do
  describe "GET /projects" do
    let!(:monday) { Date.current.beginning_of_week }
    let!(:sunday) { monday + 6.days }
    let!(:project1) { create(:project, name: "Apples", expected_weekly_hours: 10) }
    let!(:project2) { create(:project, name: "Oranges", expected_weekly_hours: 20) }
    let!(:project3) { create(:project, name: "Bananas", expected_weekly_hours: 30) }

    before do
      create(:day, project: project1, date: monday, hours: 2)
      create(:day, project: project1, date: sunday, hours: 4)
      create(:day, project: project2, date: monday, hours: 8)
      create(:day, project: project2, date: sunday, hours: 16)
    end

    context "JSON" do
      it "returns projects with this week's hours" do
        get "projects.json"

        expect(response.status).to eq(200)

        expect(JSON.load(response.body)).to eq(
          "projects" => [
            {
              "id" => project1.id,
              "name" => "Apples",
              "harvest_id" => project1.harvest_id,
              "expected_weekly_hours" => 10,
              "current_weekly_hours" => 6.0,
              "weekly_hours_met" => false
            },
            {
              "id" => project2.id,
              "name" => "Oranges",
              "harvest_id" => project2.harvest_id,
              "expected_weekly_hours" => 20,
              "current_weekly_hours" => 24.0,
              "weekly_hours_met" => true
            },
            {
              "id" => project3.id,
              "name" => "Bananas",
              "harvest_id" => project3.harvest_id,
              "expected_weekly_hours" => 30,
              "current_weekly_hours" => 0.0,
              "weekly_hours_met" => false
            }
          ]
        )
      end
    end

    context "ASCII" do
      it "returns a pretty plain text representation" do
        get "projects.txt"

        expect(response.status).to eq(200)

        expect(response.body).to eq(<<-ASCII.strip_heredoc
          Apples  │••••••••••••••••••••••••••••••                    │ 60%  (6/10)
          Oranges │••••••••••••••••••••••••••••••••••••••••••••••••••│ 120% (24/20)
          Bananas │                                                  │ 0%   (0/30)
          ASCII
        )
      end
    end
  end
end
