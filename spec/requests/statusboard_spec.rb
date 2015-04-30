describe "Panic Status Board" do
  describe "GET /statusboard" do
    before do
      @original_statusboard_days = ENV["STATUSBOARD_DAYS"]
      ENV["STATUSBOARD_DAYS"] = "3"

      @original_pto_day_hours = ENV["PTO_DAY_HOURS"]
      ENV["PTO_DAY_HOURS"] = "6.4"

      Timecop.travel(Date.new(2015, 4, 6)) # Monday
      today = Date.current

      create(:day, {
        date: today,
        client_hours: "1.10".to_d,
        internal_hours: "2.20".to_d
      })
      create(:day, {
        date: today,
        client_hours: "3.30".to_d,
        internal_hours: "4.40".to_d
      })
      create(:day, {
        date: today,
        client_hours: "0.00".to_d,
        internal_hours: "0.00".to_d,
        pto: true
      })
      create(:day, {
        date: (today - 1.day),
        client_hours: "5.50".to_d,
        internal_hours: "6.60".to_d
      })
      create(:day, {
        date: (today - 2.days),
        client_hours: "7.70".to_d,
        internal_hours: "8.80".to_d
      })
      create(:day, {
        date: (today - 3.days),
        client_hours: "9.90".to_d,
        internal_hours: "11.00".to_d
      })
      create(:day, {
        date: (today + 1.day),
        client_hours: "12.00".to_d,
        internal_hours: "12.00".to_d
      })
    end

    after do
      ENV["STATUSBOARD_DAYS"] = @original_statusboard_days
      ENV["PTO_DAY_HOURS"] = @original_pto_day_hours
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
                { "title" => "Saturday",  "value" => 8 }, # 7.70
                { "title" => "Yesterday", "value" => 6 }, # 5.50
                { "title" => "Today",     "value" => 4 }  # 1.10 + 3.30
              ]
            },
            {
              "title" => "Internal",
              "color" => "blue",
              "datapoints" => [
                { "title" => "Saturday",  "value" => 9 }, # 8.80
                { "title" => "Yesterday", "value" => 7 }, # 6.60
                { "title" => "Today",     "value" => 7 }  # 2.20 + 4.40
              ]
            },
            {
              "title" => "PTO",
              "color" => "red",
              "datapoints" => [
                { "title" => "Saturday",  "value" => 0 },
                { "title" => "Yesterday", "value" => 0 },
                { "title" => "Today",     "value" => 6 }  # 6.40
              ]
            }
          ]
        }
      )
    end
  end
end
