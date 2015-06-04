describe "Slack Command" do
  describe "POST /slack" do
    let!(:user) { create(:user) }

    before do
      Timecop.travel(Date.new(2015, 4, 10)) # Friday
      today = Date.current

      create(:day, {
        user: user,
        date: today, # 2015-04-10
        client_hours: 0.0,
        internal_hours: 0.1
      })
      create(:day, {
        user: user,
        date: today - 1.day, # 2015-04-09
        client_hours: 0.1,
        internal_hours: 0.2
      })
      create(:day, {
        user: user,
        date: today.monday, # 2015-04-06
        client_hours: 0.2,
        internal_hours: 0.4
      })
      create(:day, {
        user: user,
        date: today.monday - 1.week, # 2015-03-30
        client_hours: 0.4,
        internal_hours: 0.8
      })
      create(:day, {
        user: user,
        date: today.beginning_of_month, # 2015-04-01
        client_hours: 0.8,
        internal_hours: 1.6
      })
      create(:day, {
        user: user,
        date: today.beginning_of_month - 1.month, # 2015-03-01
        client_hours: 1.6,
        internal_hours: 3.2
      })
      create(:day, {
        user: user,
        date: today.beginning_of_month - 1.month - 1.day, # 2015-02-28
        client_hours: 3.2,
        internal_hours: 6.4
      })
    end

    it "returns the user's hours for today" do
      get "/slack", { text: "today", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for April 10
        0.0 client (0%)
        0.1 internal (100%)
        0.1 total
        MSG
    end

    it "returns the user's hours for yesterday" do
      get "/slack", { text: "yesterday", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for April 9
        0.1 client (33%)
        0.2 internal (67%)
        0.3 total
        MSG
    end

    it "returns the user's hours for a given weekday" do
      get "/slack", { text: "thursday", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for April 9
        0.1 client (33%)
        0.2 internal (67%)
        0.3 total
        MSG
    end

    it "returns the user's hours for this week" do
      get "/slack", { text: "this week", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for April 6 – 12
        0.3 client (30%)
        0.7 internal (70%)
        1.0 total
        MSG
    end

    it "returns the user's hours for last week" do
      get "/slack", { text: "last week", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for March 30 – April 5
        1.2 client (33%)
        2.4 internal (67%)
        3.6 total
        MSG
    end

    it "returns the user's hours for this month" do
      get "/slack", { text: "this month", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for April 1 – 30
        1.1 client (32%)
        2.3 internal (68%)
        3.4 total
        MSG
    end

    it "returns the user's hours for last month" do
      get "/slack", { text: "last month", user_id: user.slack_id }

      expect(response.status).to eq(200)
      expect(response.body).to eq(<<-MSG.strip_heredoc)
        Hours for March 1 – 31
        4.0 client
        4.0 internal
        8.0 total
        MSG
    end

    it "returns nothing for an invalid command" do
      get "/slack", { text: "tomorrow", user_id: user.slack_id }

      expect(response.status).to eq(204)
      expect(response.body).to be_blank
    end
  end
end
