describe SendTimerReminders do
  let(:harvest) { double(Harvest::HardyClient) }
  let(:harvest_time) { double(Harvest::API::Time) }
  let(:today) { Date.current }

  before do
    allow(Harvest).to receive(:hardy_client).with(
      subdomain: ENV["HARVEST_SUBDOMAIN"],
      username: ENV["HARVEST_USERNAME"],
      password: ENV["HARVEST_PASSWORD"]
    ) { harvest }

    allow(harvest).to receive(:time).with(no_args) { harvest_time }
  end

  it "sends a reminder for any user who hasn't started a timer yet today" do
    user_1 = create(:user, email: "john@example.com")
    user_2 = create(:user, email: "jane@example.com")

    expect(harvest_time).to receive(:all).with(today, user_1.harvest_id) {
      [
        create(:harvest_time_entry, :in_progress, hours_without_timer: 0.0)
      ]
    }

    expect(harvest_time).to receive(:all).with(today, user_2.harvest_id) { [] }

    SendTimerReminders.call

    expect(mailbox_for(user_1.email)).to be_empty

    open_last_email_for(user_2.email)
    expect(current_email).to have_i18n_subject_for("timer_reminder")
  end

  it "only sends one reminder per day" do
    user = create(:user)

    expect(harvest_time).to receive(:all).with(today, user.harvest_id) { [] }

    expect {
      SendTimerReminders.call
    }.to change {
      mailbox_for(user.email).size
    }.from(0).to(1)

    expect {
      SendTimerReminders.call
    }.not_to change {
      mailbox_for(user.email).size
    }
  end

  it "doesn't send a reminder on a PTO day" do
    user = create(:user)
    create(:day, user: user, date: today, pto: true)

    allow(harvest_time).to receive(:all).with(today, user.harvest_id) {
      [
        create(:harvest_time_entry, :in_progress, hours_without_timer: 0.0)
      ]
    }

    expect {
      SendTimerReminders.call
    }.not_to change {
      mailbox_for(user.email).size
    }
  end
end
