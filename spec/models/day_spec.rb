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

  context "callbacks" do
    describe "#set_month_number" do
      it "sets the month number according to the date" do
        day = build(:day, date: "2014-12-29") # Monday

        expect {
          day.save!
        }.to change {
          day.month_number
        }.from(nil).to("201412")
      end
    end

    describe "#set_week_number" do
      it "sets the week-based year week number according to the date" do
        day = build(:day, date: "2014-12-29") # Monday

        expect {
          day.save!
        }.to change {
          day.week_number
        }.from(nil).to("201501")
      end

      it "considers Monday the start of the week" do
        day = build(:day, date: "2014-12-28") # Sunday

        expect {
          day.save!
        }.to change {
          day.week_number
        }.from(nil).to("201452")
      end
    end
  end
end
