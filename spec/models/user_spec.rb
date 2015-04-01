describe User do
  context "validations" do
    subject(:user) { User.new }

    describe "name" do
      it { is_expected.to accept_values_for(:name, "John") }
      it { is_expected.not_to accept_values_for(:name, nil) }
    end

    describe "email" do
      it { is_expected.to accept_values_for(:email, "foo@example.com") }
      it { is_expected.not_to accept_values_for(:email, nil, "foo@bar") }
    end

    describe "harvest_id" do
      it { is_expected.to accept_values_for(:harvest_id, "123", "abc") }
      it { is_expected.not_to accept_values_for(:harvest_id, nil) }

      it "requires a unique value" do
        create(:user, harvest_id: "123")

        expect(user).not_to accept_values_for(:harvest_id, "123")
      end
    end

    describe "zenefits_name" do
      it { is_expected.to accept_values_for(:zenefits_name, "John Doe") }
      it { is_expected.not_to accept_values_for(:zenefits_name, nil) }

      it "requires a unique value" do
        create(:user, zenefits_name: "John Doe")

        expect(user).not_to accept_values_for(:zenefits_name, "John Doe")
      end
    end

    describe "time_zone" do
      it { is_expected.to accept_values_for(:time_zone, "Hawaii") }
      it { is_expected.not_to accept_values_for(:time_zone, nil, "Foo Bar") }
    end
  end
end
