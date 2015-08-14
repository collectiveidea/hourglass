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
    let!(:user) { create(:user, workdays: %w(1 2)) }
    let(:client_hours) { 0 }
    let(:internal_hours) { 0 }
    let(:pto) { false }
    let(:timer_reminder_sent) { false }
    let(:workday) { true }

    let!(:day) { create(:day, date: date, user: user, client_hours: client_hours,
                       internal_hours: internal_hours, pto: pto,
                       timer_reminder_sent: timer_reminder_sent, 
                       workday: workday) }


    it "includes users that work that day and haven't started a timer" do
      expect(User.for_timer_reminder(date: date)).to include(user)
    end

    context "not working that day" do
      let(:workday) { false }

      it "doesn't include the user" do
        expect(User.for_timer_reminder(date: date)).not_to include(user)
      end
    end

    context "has client hours for that day" do
      let(:client_hours) { 3 }

      it "doesn't include the user" do
        expect(User.for_timer_reminder(date: date)).not_to include(user)
      end
    end

    context "has internal hours for that day" do
      let(:internal_hours) { 2 }

      it "doesn't include the user" do
        expect(User.for_timer_reminder(date: date)).not_to include(user)
      end
    end

    context "on PTO" do
      let(:pto) { true }

      it "doesn't include the user" do
        expect(User.for_timer_reminder(date: date)).not_to include(user)
      end
    end

    context "timer_reminder_sent" do
      let(:timer_reminder_sent) { true }

      it "doesn't include the user" do
        expect(User.for_timer_reminder(date: date)).not_to include(user)
      end
    end
  end

  describe "#timer_reminder_sent!" do
    let(:user) { create(:user) }
    let!(:tomorrow_day) { create(:day, date: Date.tomorrow, user: user) }
    let!(:today_day) { create(:day, date: Date.current, user: user) }

    it "sets the day's timer_reminder_sent to true when date passed" do
      user.timer_reminder_sent!(date: Date.tomorrow)
      tomorrow_day.reload

      expect(tomorrow_day.timer_reminder_sent).to eq(true)
    end

    it "sets today's timer_reminder_sent to true when no date passed" do
      user.timer_reminder_sent!
      today_day.reload

      expect(today_day.timer_reminder_sent).to eq(true)
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
