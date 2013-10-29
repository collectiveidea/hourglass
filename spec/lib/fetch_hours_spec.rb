require "spec_helper"

describe FetchHours, vcr: { cassette_name: "time_by_project", match_requests_on: [:method, :host, :path] } do
  describe ".perform" do
    let!(:project) { create(:project, harvest_id: 3192065) }

    context "when today is recorded" do
      it "updates the day's hours" do
        day = create(:day, project: project, date: Date.current, hours: 1)

        expect {
          FetchHours.perform
        }.to change {
          day.reload.hours
        }.from("1.00".to_d).to("4.30".to_d)
      end
    end

    context "when today isn't recorded" do
      it "creates a day with its hours" do
        expect {
          FetchHours.perform
        }.to change {
          Day.count
        }.from(0).to(1)

        day = Day.last
        expect(day.project).to eq(project)
        expect(day.date).to eq(Date.current)
        expect(day.hours).to eq("4.30".to_d)
      end
    end
  end
end
