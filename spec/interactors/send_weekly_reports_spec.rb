describe SendWeeklyReports do
  it "sends a report for every user" do
    user_1 = create(:user, email: "john@example.com")
    user_2 = create(:user, email: "jane@example.com")
    create(:day, {
      user: user_2,
      date: 1.week.ago.to_date.monday,
      client_hours: "1.23".to_d,
      internal_hours: "2.34".to_d
    })
    create(:day, {
      user: user_2,
      date: 1.week.ago.to_date.sunday,
      client_hours: "4.56".to_d,
      internal_hours: "8.90".to_d
    })

    SendWeeklyReports.call

    open_last_email_for(user_1.email)
    expect(current_email).to have_i18n_subject_for("weekly_report")

    open_last_email_for(user_2.email)
    expect(current_email).to have_i18n_subject_for("weekly_report")
    expect(current_email).to have_body_text("5.8 hours")
    expect(current_email).to have_body_text("11.2 hours")
    expect(current_email).to have_body_text("17.0 hours")
  end
end
