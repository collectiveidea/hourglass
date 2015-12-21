describe Day do
  context "validations" do
    subject(:day) { Day.new }

    describe "date" do
      it { is_expected.to accept_values_for(:date, "2015-04-01", Date.current) }
      it { is_expected.not_to accept_values_for(:date, nil, "foo-bar-baz") }

      it "is unique per user" do
        existing_day = create(:day)
        day = build(:day, user: existing_day.user)

        expect(day).to accept_values_for(:date, existing_day.date + 1.day)
        expect(day).not_to accept_values_for(:date, existing_day.date)
      end
    end

    describe "client_hours" do
      it { is_expected.to accept_values_for(:client_hours, 0, 1.23, "99.99") }
      it { is_expected.not_to accept_values_for(:client_hours, -1, nil, 100) }
    end

    describe "internal_hours" do
      it { is_expected.to accept_values_for(:internal_hours, 0, 1.23, "99.99") }
      it { is_expected.not_to accept_values_for(:internal_hours, -1, nil, 100) }
    end
  end

  describe ".ensure" do
    it "specifies whether the day is a workday for the given user" do
      date = Date.new(2015, 7, 22) # Wednesday

      user_1 = create(:user, workdays: %w(1 2 3 4 5)) # M, Tu, W, Th, F
      user_2 = create(:user, workdays: %w(1 2 4 5 6)) # M, Tu, Th, F, Sa

      expect {
        Day.ensure(user: user_1, date: date)
        Day.ensure(user: user_2, date: date)
      }.to change {
        Day.count
      }.from(0).to(2)

      day_1 = user_1.days.last
      expect(day_1.date).to eq(date)
      expect(day_1).to be_a_workday

      day_2 = user_2.days.last
      expect(day_2.date).to eq(date)
      expect(day_2).not_to be_a_workday
    end
  end

  describe ".clear_future" do
    it "deletes all days set in the future" do
      create(:day, date: Date.yesterday)
      create(:day, date: Date.current)
      create(:day, date: Date.tomorrow)

      expect {
        Day.clear_future
      }.to change {
        Day.count
      }.from(3).to(2)

      expect(Day.pluck(:date)).to match_array([Date.yesterday, Date.current])
    end
  end
end
