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

  describe ".for_timer_reminder" do
    let(:date) { Date.parse("Monday") }

    before do
      @user = create(:user, workdays: %w(1 2))
      @other_user = create(:user, workdays: %w(4))
      day = create(:day, date: date, user: @user, client_hours: 0,
                   internal_hours: 0, pto: false,
                   timer_reminder_sent: false, workday: true)
    end

    it "includes users that work that day and haven't started a timer" do
      expect(User.for_timer_reminder(date: date)).to include(@user)
    end

    it "doesn't include other users" do
      expect(User.for_timer_reminder(date: date)).not_to include(@other_user)
    end
  end

  describe "#timer_reminder_sent!" do
    before do
      @user = create(:user)
      @tomorrow_day = create(:day, date: Date.tomorrow, user: @user)
      @today_day = create(:day, date: Date.current, user: @user)
    end

    it "sets the day's timer_reminder_sent to true when date passed" do
      @user.timer_reminder_sent!(date: Date.tomorrow)
      @tomorrow_day.reload

      expect(@tomorrow_day.timer_reminder_sent).to eq(true)
    end

    it "sets today's timer_reminder_sent to true when no date passed" do
      @user.timer_reminder_sent!
      @today_day.reload

      expect(@today_day.timer_reminder_sent).to eq(true)
    end
  end

  describe "#works_on?" do
    let(:user) { create(:user, workdays: %w(1 2 3)) }

    it "returns true when the passed date is among the user's workdays" do
      monday_workday = Date.parse("Monday") + 7.days

      expect(user.works_on?(date: monday_workday)).to be(true)
    end

    it "returns false when the passed date is not among the user's workdays" do
      friday_workday = Date.parse("Friday") + 7.days

      expect(user.works_on?(date: friday_workday)).to be(false)
    end
  end

  describe "#workdays=" do
    let(:user) { create(:user) }
    let(:day_values) { %w(1 2 3 4 5) }

    it "assigns the passed values as the user's workdays attribute" do
      user.workdays = day_values

      expect(user.workdays).to eq(day_values)
    end

    it "rejects any blank values" do
      day_values_with_blank = %w(1 2 3 4 5) << nil
      user.workdays = day_values_with_blank

      expect(user.workdays).to eq(day_values)
    end
  end

  describe "#archive" do
    let(:user) { create(:user, :active) }

    it "sets a user's active attribute to false" do
      user.archive

      expect(user).not_to be_active
    end
  end
end
