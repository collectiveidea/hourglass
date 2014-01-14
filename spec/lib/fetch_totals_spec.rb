require "spec_helper"

describe FetchTotals, vcr: { cassette_name: "date_totals", match_requests_on: [:method, :host, :path] } do
  describe ".perform" do
    let(:date) { Date.new(2013, 11, 13) }

    context "when the date total is recorded" do
      it "updates the date totals" do
        date_total = create(:date_total, date: date, billable_hours: 1.0)

        expect {
          FetchTotals.perform(date)
        }.to change {
          date_total.reload.billable_hours
        }.from("1.00".to_d).to("6.67".to_d)
      end
    end

    context "when the date total isn't recorded" do
      it "creates a date total with its hours" do
        expect {
          FetchTotals.perform(date)
        }.to change {
          DateTotal.count
        }.from(0).to(1)

        date_total = DateTotal.last
        expect(date_total.date).to eq(date)
        expect(date_total.billable_hours).to eq("6.67".to_d)
      end
    end
  end
end
