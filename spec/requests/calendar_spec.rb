describe "iCal Calendars" do
  describe "GET /pto.ics" do
    before do
      @original_calendar_password = ENV["CALENDAR_PASSWORD"]
      @password = ENV["CALENDAR_PASSWORD"] = "s3cr3t"
    end

    after do
      ENV["CALENDAR_PASSWORD"] = @original_calendar_password
      Rails.cache.clear
    end

    it "returns a cached response when authenticated" do
      random_string = SecureRandom.uuid
      Rails.cache.write("pto.ics", random_string)

      get "/pto.ics", nil,
        "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials(@password, nil)

      expect(response.status).to eq(200)
      expect(response.content_type).to eq("text/calendar")
      expect(response.body).to eq(random_string)
    end

    it "returns a cached response when not authenticated" do
      random_string = SecureRandom.uuid
      Rails.cache.write("pto.ics", random_string)

      get "/pto.ics"

      expect(response.status).to eq(401)
      expect(response.body).not_to include(random_string)
    end

    it "returns a cached response when authenticated with the wrong password" do
      random_string = SecureRandom.uuid
      Rails.cache.write("pto.ics", random_string)

      get "/pto.ics", nil,
        "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials("wr0ng", nil)

      expect(response.status).to eq(401)
      expect(response.body).not_to include(random_string)
    end
  end
end
