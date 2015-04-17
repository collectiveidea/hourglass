describe "Panic Status Board" do
  describe "GET /statusboard" do
    before do
      @original_statusboard_days = ENV["STATUSBOARD_DAYS"]
      ENV["STATUSBOARD_DAYS"] = "3"

      Timecop.travel(Date.new(2015, 4, 6)) # Monday
      today = Date.current

      create(:day, {
        date: today,
        client_hours: "0.01".to_d,
        internal_hours: "0.02".to_d
      })
      create(:day, {
        date: today,
        client_hours: "0.04".to_d,
        internal_hours: "0.08".to_d
      })
      create(:day, {
        date: (today - 1.day),
        client_hours: "0.16".to_d,
        internal_hours: "0.32".to_d
      })
      create(:day, {
        date: (today - 2.days),
        client_hours: "0.64".to_d,
        internal_hours: "1.28".to_d
      })
      create(:day, {
        date: (today - 3.days),
        client_hours: "2.56".to_d,
        internal_hours: "5.12".to_d
      })
      create(:day, {
        date: (today + 1.day),
        client_hours: "12.00".to_d,
        internal_hours: "12.00".to_d
      })
    end

    after do
      ENV["STATUSBOARD_DAYS"] = @original_statusboard_days
    end

    it "returns projects with this week's hours" do
      get "/statusboard"

      expect(response.status).to eq(200)
      expect(JSON.load(response.body)).to eq(
        "graph" => {
          "title" => "Time Tracking",
          "total" => true,
          "datasequences" => [
            {
              "title" => "Client",
              "color" => "green",
              "datapoints" => [
                { "title" => "Saturday",  "value" => 0.64 },
                { "title" => "Yesterday", "value" => 0.16 },
                { "title" => "Today",     "value" => 0.05 }
              ]
            },
            {
              "title" => "Internal",
              "color" => "blue",
              "datapoints" => [
                { "title" => "Saturday",  "value" => 1.28 },
                { "title" => "Yesterday", "value" => 0.32 },
                { "title" => "Today",     "value" => 0.10 }
              ]
            }
          ]
        }
      )
    end
  end
end
