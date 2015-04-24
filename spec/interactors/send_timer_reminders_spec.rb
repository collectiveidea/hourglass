describe SendTimerReminders do
  let(:today) { Date.current }

  it "sends a reminder for any user who hasn't started a timer yet today" do
    user_1 = create(:user, email: "john@example.com")
    user_2 = create(:user, email: "jane@example.com")
    day_1 = create(:day, {
      user: user_1,
      date: today,
      client_hours: 0,
      internal_hours: 1,
      pto: false
    })
    day_2 = create(:day, {
      user: user_2,
      date: today,
      client_hours: 0,
      internal_hours: 0,
      pto: false
    })

    SendTimerReminders.call

    expect(mailbox_for(user_1.email)).to be_empty
    expect(day_1.reload.timer_reminder_sent).to be_falsey

    open_last_email_for(user_2.email)
    expect(current_email).to have_i18n_subject_for("timer_reminder")
    expect(day_2.reload.timer_reminder_sent).to be_truthy
  end

  it "only sends one reminder per day" do
    user = create(:user)
    create(:day, {
      user: user,
      date: today,
      client_hours: 0,
      internal_hours: 0,
      pto: false
    })

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
    create(:day, {
      user: user,
      date: today,
      client_hours: 0,
      internal_hours: 0,
      pto: true
    })

    expect {
      SendTimerReminders.call
    }.not_to change {
      mailbox_for(user.email).size
    }
  end
end
