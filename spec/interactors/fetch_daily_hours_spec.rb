describe FetchDailyHours do
  let(:harvest) { double(Harvest::HardyClient) }
  let(:harvest_time) { double(Harvest::API::Time) }
  let(:harvest_projects) { double(Harvest::API::Projects) }

  before do
    allow(Harvest).to receive(:hardy_client).with(
      subdomain: ENV["HARVEST_SUBDOMAIN"],
      username: ENV["HARVEST_USERNAME"],
      password: ENV["HARVEST_PASSWORD"]
    ) { harvest }

    allow(harvest).to receive(:time).with(no_args) { harvest_time }
    allow(harvest).to receive(:projects).with(no_args) { harvest_projects }

    allow(harvest_projects).to receive(:all).with(no_args) {
      [
        create(:harvest_project, id: 1, client_id: 100),
        create(:harvest_project, id: 2, client_id: 200)
      ]
    }
  end

  it "creates a day with today's hours for every user" do
    today = Date.current
    user_1, user_2 = create_pair(:user)
    responsibility_1 = create(:responsibility, harvest_client_ids: [100])
    responsibility_2 = create(:responsibility, harvest_client_ids: [200])

    expect(harvest_time).to receive(:all).
      with(today, user_1.harvest_id) {
        [
          create(:harvest_time_entry, hours: 1.0, project_id: "1"),
          create(:harvest_time_entry, hours: 2.0, project_id: "2"),
          create(:harvest_time_entry, hours: 4.0, project_id: "1"),
          create(:harvest_time_entry, hours: 8.0, project_id: "2")
        ]
      }

    expect(harvest_time).to receive(:all).
      with(today, user_2.harvest_id) {
        [
          create(:harvest_time_entry, hours: 0.1, project_id: "1"),
          create(:harvest_time_entry, hours: 0.2, project_id: "2"),
          create(:harvest_time_entry, hours: 0.4, project_id: "1"),
          create(:harvest_time_entry, hours: 0.8, project_id: "2")
        ]
      }

    expect {
      FetchDailyHours.call
    }.to change {
      Day.count
    }.from(0).to(2)

    day_1 = user_1.days.last
    expect(day_1.date).to eq(today)
    expect(day_1.hours).to be_a(Hash)
    expect(day_1.hours.keys).to contain_exactly(
      responsibility_1.id,
      responsibility_2.id,
    )
    expect(day_1.hours[responsibility_1.id]).to eq(5.0)
    expect(day_1.hours[responsibility_2.id]).to eq(10.0)

    day_2 = user_2.days.last
    expect(day_2.date).to eq(today)
    expect(day_2.hours).to be_a(Hash)
    expect(day_2.hours.keys).to contain_exactly(
      responsibility_1.id,
      responsibility_2.id,
    )
    expect(day_2.hours[responsibility_1.id]).to eq(0.5)
    expect(day_2.hours[responsibility_2.id]).to eq(1.0)
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

  it "notes whether a user is tracking in real time" do
    today = Date.current
    user = create(:user)
    time_entries = []

    allow(harvest_time).to receive(:all).with(today, user.harvest_id) {
      time_entries
    }

    FetchDailyHours.call

    day = Day.last
    expect(day).not_to be_tracked_in_real_time

    time_entries.replace([create(:harvest_time_entry)])
    FetchDailyHours.call

    expect(day.reload).not_to be_tracked_in_real_time

    time_entries.replace([create(:harvest_time_entry, :in_progress)])
    FetchDailyHours.call

    expect(day.reload).to be_tracked_in_real_time

    time_entries.replace([create(:harvest_time_entry)])
    FetchDailyHours.call

    expect(day.reload).to be_tracked_in_real_time
  end

  it "doesn't fetch hours for inactive users" do
    user_1 = create(:user, :active)
    user_2 = create(:user, :inactive)

    expect(harvest_time).to receive(:all) { [] }

    expect {
      FetchDailyHours.call
    }.to change {
      Day.count
    }.from(0).to(1)

    expect(user_1.days.count).to eq(1)
    expect(user_2.days.count).to eq(0)
  end
end
