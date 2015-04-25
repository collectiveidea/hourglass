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
end
