describe TeamDay do
  describe ".for_date_range" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }

    let(:monday) { Date.parse("Monday") }
    let(:tuesday) { monday + 1.day }
    let(:friday) { monday + 4.days }
    let(:date_range) { (monday..friday) }

    let!(:day1) { create(:day, user: user, date: monday, client_hours: 4.3,
                    internal_hours: 2.5, pto: false) }
    let!(:day2) { create(:day, user: user, date: tuesday) }
    let!(:day3) { create(:day, user: user2, date: monday, client_hours: 2.8,
                    internal_hours: 6.0, pto: false) }
    let!(:day4) { create(:day, user: user3, date: monday, client_hours: 0.0,
                    internal_hours: 0.0, pto: true) }

    let(:team_days) { TeamDay.for_date_range(date_range) }

    it "creates the right number of team_days" do
      expect(team_days.size).to eq(2)
    end

    describe "days exist for a date" do
      let(:monday_team_days) { team_days.select{ |d| d.date == monday } }
      let(:tuesday_team_days) { team_days.select{ |d| d.date == tuesday } }

      it "creates only one team_day for each date" do

        expect(monday_team_days.size).to eq(1)
        expect(tuesday_team_days.size).to eq(1)
      end

      let(:monday_team_day) { monday_team_days.first }

      it "sums all team members' client_hours" do
        expect(monday_team_day.client_hours).to eq(7.1)
      end

      it "sums all team members' internal_hours" do
        expect(monday_team_day.internal_hours).to eq(8.5)
      end

      it "sums all team members' pto_hours" do
        expect(monday_team_day.pto_hours).to eq(8.0)
      end
    end

    describe "days do not exist for a date" do
      it "creates no team_day" do
        friday_team_days = team_days.select{ |d| d.date == friday }

        expect(friday_team_days.size).to eq(0)
      end
    end
  end
end