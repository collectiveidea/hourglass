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
  end

  describe ".last_week" do
    it "returns days from last week (Monday-Sunday)" do
      create(:day, date: 2.weeks.ago.to_date.sunday)
      day_1 = create(:day, date: 1.week.ago.to_date.monday)
      day_2 = create(:day, date: 1.week.ago.to_date.monday + 1.day)
      day_3 = create(:day, date: 1.week.ago.to_date.monday + 2.days)
      day_4 = create(:day, date: 1.week.ago.to_date.monday + 3.days)
      day_5 = create(:day, date: 1.week.ago.to_date.monday + 4.days)
      day_6 = create(:day, date: 1.week.ago.to_date.monday + 5.days)
      day_7 = create(:day, date: 1.week.ago.to_date.monday + 6.days)
      create(:day, date: Date.current.monday)

      expect(Day.last_week).to eq([
        day_1,
        day_2,
        day_3,
        day_4,
        day_5,
        day_6,
        day_7
      ])
    end

    it "properly handles a year boundary in the middle of a week" do
      Timecop.travel(Date.new(2015, 1, 9))

      create(:day, date: 2.weeks.ago.to_date.sunday)
      day_1 = create(:day, date: 1.week.ago.to_date.monday)
      day_2 = create(:day, date: 1.week.ago.to_date.monday + 1.day)
      day_3 = create(:day, date: 1.week.ago.to_date.monday + 2.days)
      day_4 = create(:day, date: 1.week.ago.to_date.monday + 3.days)
      day_5 = create(:day, date: 1.week.ago.to_date.monday + 4.days)
      day_6 = create(:day, date: 1.week.ago.to_date.monday + 5.days)
      day_7 = create(:day, date: 1.week.ago.to_date.monday + 6.days)
      create(:day, date: Date.current.monday)

      expect(Day.last_week).to eq([
        day_1,
        day_2,
        day_3,
        day_4,
        day_5,
        day_6,
        day_7
      ])
    end
  end
end
