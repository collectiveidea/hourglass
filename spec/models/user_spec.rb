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

  describe ".time_zones" do
    it "returns an array of every unique time zone represented in the users table" do
      create(:user, time_zone: "Cairo")
      create(:user, time_zone: "Alaska")
      create(:user, time_zone: "Alaska")

      expect(User.time_zones).to eq(%w(Cairo Alaska))
    end
  end

  describe ".tags" do
    it "returns a sorted array of every unique tag represented in the users table" do
      create(:user, tags: %w(foo bar))
      create(:user, tags: %w(foo baz))
      create(:user, tags: [])

      expect(User.tags).to eq(%w(bar baz foo))
    end
  end
end
