describe Month do
  context "validations" do
    subject(:month) { Month.new }

    describe "number" do
      it { is_expected.to accept_values_for(:number, "201501", "300012") }
      it { is_expected.not_to accept_values_for(:number, nil, "foobar") }

      it "is unique per user" do
        existing_month = create(:month, number: "201504")
        month = build(:month, user: existing_month.user)

        expect(month).to accept_values_for(:number, "201505")
        expect(month).not_to accept_values_for(:number, "201504")
      end
    end
  end
end
