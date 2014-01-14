require "spec_helper"

describe "Statusboard" do
  describe "GET /statusboard" do
    let!(:today) { Date.current }
    let!(:yesterday) { today - 1 }

    before do
      create(:date_total, date: today, billable_hours: 2)
      create(:date_total, date: yesterday, billable_hours: 4)
    end

    context "JSON" do
      it "returns projects with this week's hours" do
        get "statusboard"

        expect(response.status).to eq(200)

        expect(JSON.load(response.body)).to eq(
          "title" => "Billable Hours",
          "refreshEveryNSeconds" => 3600,
          "datapoints" => [
            {
              "title" => yesterday.to_s,
              "value" => "4.0",
            },
            {
              "title" => today.to_s,
              "value" => "2.0",
            },
          ]
        )
      end
    end
  end
end
