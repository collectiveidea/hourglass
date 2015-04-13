describe FetchDailyHours do
  let(:harvest) { double(Harvest::HardyClient) }
  let(:harvest_time) { double(Harvest::API::Time) }

  before do
    allow(Harvest).to receive(:hardy_client).with(
      subdomain: ENV["HARVEST_SUBDOMAIN"],
      username: ENV["HARVEST_USERNAME"],
      password: ENV["HARVEST_PASSWORD"]
    ) { harvest }

    allow(harvest).to receive(:time).with(no_args) { harvest_time }
  end

  it "creates a day with today's hours for every user" do
    today = Date.current
    user_1, user_2 = create_pair(:user)

    expect(harvest_time).to receive(:all).
      with(today, user_1.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 1.0),
          create(:harvest_time_entry, :internal, hours: 2.0),
          create(:harvest_time_entry, :client,   hours: 4.0),
          create(:harvest_time_entry, :internal, hours: 8.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(today, user_2.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 0.1),
          create(:harvest_time_entry, :internal, hours: 0.2),
          create(:harvest_time_entry, :client,   hours: 0.4),
          create(:harvest_time_entry, :internal, hours: 0.8)
        ]
      }

    expect {
      FetchDailyHours.call
    }.to change {
      Day.count
    }.from(0).to(2)

    day_1 = user_1.days.last
    expect(day_1.date).to eq(today)
    expect(day_1.client_hours).to eq("5.0".to_d)
    expect(day_1.internal_hours).to eq("10.0".to_d)

    day_2 = user_2.days.last
    expect(day_2.date).to eq(today)
    expect(day_2.client_hours).to eq("0.5".to_d)
    expect(day_2.internal_hours).to eq("1.0".to_d)
  end

  it "updates existing days' hours for today" do
    today = Date.current
    user_1, user_2 = create_pair(:user)
    create(:day, {
      user: user_1,
      client_hours: "2.5".to_d,
      internal_hours: "5.0".to_d
    })

    expect(harvest_time).to receive(:all).
      with(today, user_1.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 1.0),
          create(:harvest_time_entry, :internal, hours: 2.0),
          create(:harvest_time_entry, :client,   hours: 4.0),
          create(:harvest_time_entry, :internal, hours: 8.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(today, user_2.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 0.1),
          create(:harvest_time_entry, :internal, hours: 0.2),
          create(:harvest_time_entry, :client,   hours: 0.4),
          create(:harvest_time_entry, :internal, hours: 0.8)
        ]
      }

    expect {
      FetchDailyHours.call
    }.to change {
      Day.count
    }.from(1).to(2)

    day_1 = user_1.days.last
    expect(day_1.date).to eq(today)
    expect(day_1.client_hours).to eq("5.0".to_d)
    expect(day_1.internal_hours).to eq("10.0".to_d)

    day_2 = user_2.days.last
    expect(day_2.date).to eq(today)
    expect(day_2.client_hours).to eq("0.5".to_d)
    expect(day_2.internal_hours).to eq("1.0".to_d)
  end

  it "accepts a specified date" do
    yesterday = Date.yesterday
    user_1, user_2 = create_pair(:user)

    expect(harvest_time).to receive(:all).
      with(1.day.ago.to_date, user_1.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 1.0),
          create(:harvest_time_entry, :internal, hours: 2.0),
          create(:harvest_time_entry, :client,   hours: 4.0),
          create(:harvest_time_entry, :internal, hours: 8.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(1.day.ago.to_date, user_2.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 0.1),
          create(:harvest_time_entry, :internal, hours: 0.2),
          create(:harvest_time_entry, :client,   hours: 0.4),
          create(:harvest_time_entry, :internal, hours: 0.8)
        ]
      }

    expect {
      FetchDailyHours.call(date: yesterday)
    }.to change {
      Day.count
    }.from(0).to(2)

    day_1 = user_1.days.last
    expect(day_1.date).to eq(yesterday)
    expect(day_1.client_hours).to eq("5.0".to_d)
    expect(day_1.internal_hours).to eq("10.0".to_d)

    day_2 = user_2.days.last
    expect(day_2.date).to eq(yesterday)
    expect(day_2.client_hours).to eq("0.5".to_d)
    expect(day_2.internal_hours).to eq("1.0".to_d)
  end

  it "accepts a date range" do
    user = create(:user)
    monday, sunday = Date.current.monday, Date.current.sunday

    expect(harvest_time).to receive(:all).
      with(monday, user.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 1.0),
          create(:harvest_time_entry, :internal, hours: 1.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(monday + 1.day, user.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 2.0),
          create(:harvest_time_entry, :internal, hours: 2.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(monday + 2.days, user.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 3.0),
          create(:harvest_time_entry, :internal, hours: 3.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(monday + 3.days, user.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 4.0),
          create(:harvest_time_entry, :internal, hours: 4.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(monday + 4.days, user.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 5.0),
          create(:harvest_time_entry, :internal, hours: 5.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(monday + 5.days, user.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 6.0),
          create(:harvest_time_entry, :internal, hours: 6.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(sunday, user.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 7.0),
          create(:harvest_time_entry, :internal, hours: 7.0)
        ]
      }

    expect {
      FetchDailyHours.call(from: monday, to: sunday)
    }.to change {
      Day.count
    }.from(0).to(7)

    days = Day.order(:date)
    expect(days[0].total_hours).to eq(2)
    expect(days[1].total_hours).to eq(4)
    expect(days[2].total_hours).to eq(6)
    expect(days[3].total_hours).to eq(8)
    expect(days[4].total_hours).to eq(10)
    expect(days[5].total_hours).to eq(12)
    expect(days[6].total_hours).to eq(14)
  end
end
