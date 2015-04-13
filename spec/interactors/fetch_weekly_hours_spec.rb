describe FetchWeeklyHours do
  let(:harvest) { double(Harvest::HardyClient) }
  let(:harvest_time) { double(Harvest::API::Time) }

  before do
    allow(Harvest).to receive(:hardy_client).with(
      subdomain: ENV["HARVEST_SUBDOMAIN"],
      username: ENV["HARVEST_USERNAME"],
      password: ENV["HARVEST_PASSWORD"]
    ) { harvest }

    allow(harvest).to receive(:time).with(no_args) { harvest_time }

    allow(harvest_time).to receive(:all) { [] }
  end

  it "creates days with hours for every day of this week, for every user" do
    monday, sunday = Date.current.monday, Date.current.sunday
    user_1, user_2 = create_pair(:user)

    expect(harvest_time).to receive(:all).
      with(monday, user_1.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 1.0),
          create(:harvest_time_entry, :internal, hours: 3.0),
          create(:harvest_time_entry, :client,   hours: 5.0),
          create(:harvest_time_entry, :internal, hours: 7.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(monday, user_2.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 0.1),
          create(:harvest_time_entry, :internal, hours: 0.3),
          create(:harvest_time_entry, :client,   hours: 0.5),
          create(:harvest_time_entry, :internal, hours: 0.7)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(sunday, user_1.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 2.0),
          create(:harvest_time_entry, :internal, hours: 4.0),
          create(:harvest_time_entry, :client,   hours: 6.0),
          create(:harvest_time_entry, :internal, hours: 8.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(sunday, user_2.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 0.2),
          create(:harvest_time_entry, :internal, hours: 0.4),
          create(:harvest_time_entry, :client,   hours: 0.6),
          create(:harvest_time_entry, :internal, hours: 0.8)
        ]
      }
    expect {
      FetchWeeklyHours.call
    }.to change {
      Day.count
    }.from(0).to(14)

    monday_1, _t, _w, _t, _f, _s, sunday_1 = user_1.days.order(:date)
    expect(monday_1.date).to eq(monday)
    expect(monday_1.client_hours).to eq("6.0".to_d)
    expect(monday_1.internal_hours).to eq("10.0".to_d)
    expect(sunday_1.date).to eq(sunday)
    expect(sunday_1.client_hours).to eq("8.0".to_d)
    expect(sunday_1.internal_hours).to eq("12.0".to_d)

    monday_2, _t, _w, _t, _f, _s, sunday_2 = user_2.days.order(:date)
    expect(monday_2.date).to eq(monday)
    expect(monday_2.client_hours).to eq("0.6".to_d)
    expect(monday_2.internal_hours).to eq("1.0".to_d)
    expect(sunday_2.date).to eq(sunday)
    expect(sunday_2.client_hours).to eq("0.8".to_d)
    expect(sunday_2.internal_hours).to eq("1.2".to_d)
  end
end
