describe FetchWeeklyHours do
  let(:harvest) { double(Harvest::HardyClient) }
  let(:harvest_time) { double(Harvest::API::Time) }

  before do
    Timecop.travel(Date.new(2015, 4, 28)) # Tuesday

    allow(Harvest).to receive(:hardy_client).with(
      subdomain: ENV["HARVEST_SUBDOMAIN"],
      username: ENV["HARVEST_USERNAME"],
      password: ENV["HARVEST_PASSWORD"]
    ) { harvest }

    allow(harvest).to receive(:time).with(no_args) { harvest_time }

    allow(harvest_time).to receive(:all) { [] }
  end

  it "creates days with hours for every day of this week, for every user" do
    wednesday, tuesday = 6.days.ago.to_date, Date.current
    user_1, user_2 = create_pair(:user)

    expect(harvest_time).to receive(:all).
      with(wednesday, user_1.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 1.0),
          create(:harvest_time_entry, :internal, hours: 3.0),
          create(:harvest_time_entry, :client,   hours: 5.0),
          create(:harvest_time_entry, :internal, hours: 7.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(wednesday, user_2.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 0.1),
          create(:harvest_time_entry, :internal, hours: 0.3),
          create(:harvest_time_entry, :client,   hours: 0.5),
          create(:harvest_time_entry, :internal, hours: 0.7)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(tuesday, user_1.harvest_id) {
        [
          create(:harvest_time_entry, :client,   hours: 2.0),
          create(:harvest_time_entry, :internal, hours: 4.0),
          create(:harvest_time_entry, :client,   hours: 6.0),
          create(:harvest_time_entry, :internal, hours: 8.0)
        ]
      }

    expect(harvest_time).to receive(:all).
      with(tuesday, user_2.harvest_id) {
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

    wednesday_1, _t, _w, _t, _f, _s, tuesday_1 = user_1.days
    expect(wednesday_1.date).to eq(wednesday)
    expect(wednesday_1.client_hours).to eq("6.0".to_d)
    expect(wednesday_1.internal_hours).to eq("10.0".to_d)
    expect(tuesday_1.date).to eq(tuesday)
    expect(tuesday_1.client_hours).to eq("8.0".to_d)
    expect(tuesday_1.internal_hours).to eq("12.0".to_d)

    wednesday_2, _t, _w, _t, _f, _s, tuesday_2 = user_2.days
    expect(wednesday_2.date).to eq(wednesday)
    expect(wednesday_2.client_hours).to eq("0.6".to_d)
    expect(wednesday_2.internal_hours).to eq("1.0".to_d)
    expect(tuesday_2.date).to eq(tuesday)
    expect(tuesday_2.client_hours).to eq("0.8".to_d)
    expect(tuesday_2.internal_hours).to eq("1.2".to_d)
  end
end
