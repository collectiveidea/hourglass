describe "Slack Command" do
  describe "POST /slack" do
    let!(:user) { create(:user) }

    before do
      Timecop.travel(Date.new(2015, 4, 3))
      today = Date.current

      create(:day, {
        user: user,
        date: today,
        client_hours: 6.4,
        internal_hours: 1.6
      })
      create(:day, {
        user: user,
        date: today.monday,
        client_hours: 6.4,
        internal_hours: 1.6
      })
      create(:day, {
        user: user,
        date: today.beginning_of_month,
        client_hours: 6.4,
        internal_hours: 1.6
      })
      create(:day, {
        user: user,
        date: today.beginning_of_month - 1.day
      })
    end

    it "returns the user's hours for the day" do
      get "/slack", { text: "day", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for April 3
        6.4 client
        1.6 internal
        8.0 total
        MSG
    end

    it "returns the user's hours for the week" do
      get "/slack", { text: "week", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for March 30 – April 5
        19.2 client
        4.8 internal
        24.0 total
        MSG
    end

    it "returns the user's hours for the month" do
      get "/slack", { text: "month", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for April 1 – 30
        12.8 client
        3.2 internal
        16.0 total
        MSG
    end
  end
end
