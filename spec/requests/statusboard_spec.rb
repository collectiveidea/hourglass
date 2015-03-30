require "spec_helper"

describe "Statusboard" do
  describe "GET /statusboard" do
    let!(:today) { Date.current }
    let!(:yesterday) { today - 1 }
    let!(:day_before) { today - 2 }

    before do
      create(:date_total, date: today,      billable_hours: 2, unbillable_hours: 1)
      create(:date_total, date: yesterday,  billable_hours: 4, unbillable_hours: 3)
      create(:date_total, date: day_before, billable_hours: 7, unbillable_hours: 6)
    end

    context "JSON" do
      it "returns projects with this week's hours" do
        get "statusboard"

        expect(response.status).to eq(200)

        expect(JSON.load(response.body)).to eq(
          "graph" => {
            "title" => "Time Tracking",
            "datasequences" => [
              {
                "title" => "Client",
                "color" => "green",
                "datapoints" => [
                  {
                    "title" => day_before.strftime('%A'),
                    "value" => 7.00,
                  },
                  {
                    "title" => "Yesterday",
                    "value" => 4.00,
                  },
                  {
                    "title" => "Today",
                    "value" => 2.00,
                  },
                ]
              },
              {
                "title" => "Internal",
                "color" => "blue",
                "datapoints" => [
                  {
                    "title" => day_before.strftime('%A'),
                    "value" => 6.00,
                  },
                  {
                    "title" => "Yesterday",
                    "value" => 3.00,
                  },
                  {
                    "title" => "Today",
                    "value" => 1.00,
                  },
                ]
              },
            ]
          }
        )
      end
    end
  end
end
