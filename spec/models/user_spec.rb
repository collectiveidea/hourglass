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

      it "must be unique" do
        create(:user, :active, email: "foo@example.com")

        expect(user).to accept_values_for(:email, "bar@example.com")
        expect(user).not_to accept_values_for(:email, "foo@example.com")
        expect(user).not_to accept_values_for(:email, "FOO@example.com")
      end

      it "may be non-unique if taken by an inactive user" do
        create(:user, :inactive, email: "foo@example.com")

        expect(user).to accept_values_for(:email, "bar@example.com")
        expect(user).to accept_values_for(:email, "foo@example.com")
      end
    end

    describe "harvest_id" do
      it { is_expected.to accept_values_for(:harvest_id, "123", "abc") }
      it { is_expected.not_to accept_values_for(:harvest_id, nil) }

      it "requires a unique value" do
        create(:user, harvest_id: "123")

        expect(user).not_to accept_values_for(:harvest_id, "123")
      end
    end

    describe "slack_id" do
      it { is_expected.to accept_values_for(:slack_id, "john-doe", "1234") }
      it { is_expected.not_to accept_values_for(:slack_id, nil) }

      it "requires a unique value" do
        create(:user, slack_id: "john-doe")

        expect(user).not_to accept_values_for(:slack_id, "john-doe")
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
