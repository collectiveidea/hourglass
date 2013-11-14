require "spec_helper"

describe FetchDay, vcr: { cassette_name: "time_by_project", match_requests_on: [:method, :host, :path] } do
  describe ".perform" do
    let!(:project) { create(:project, harvest_id: 3192065) }
    let(:date) { Date.new(2013, 11, 13) }

    context "when the day is recorded" do
      it "updates the day's hours" do
        day = create(:day, project: project, date: date, hours: 1)

        expect {
          FetchDay.perform(date)
        }.to change {
          day.reload.hours
        }.from("1.00".to_d).to("4.30".to_d)
      end
    end

    context "when the day isn't recorded" do
      it "creates a day with its hours" do
        expect {
          FetchDay.perform(date)
        }.to change {
          Day.count
        }.from(0).to(1)

        day = Day.last
        expect(day.project).to eq(project)
        expect(day.date).to eq(date)
        expect(day.hours).to eq("4.30".to_d)
      end
    end
  end
end
