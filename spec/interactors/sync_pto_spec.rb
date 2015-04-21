describe SyncPTO do
  let!(:user_1) { create(:user, zenefits_name: "John Doe") }
  let!(:user_2) { create(:user, zenefits_name: "Jane Doe") }
  let(:holiday) { Date.new(2015, 5, 25) } # Company holiday
  let(:vacation) { Date.new(2015, 5, 26) } # Personal vacation

  before do
    Timecop.travel(Date.new(2015, 5, 1))

    stub_request(:get, ENV["ZENEFITS_PTO_CALENDAR_URL"]).
      to_return(Rails.root.join("spec/fixtures/pto.ics").read)
  end

  it "creates PTO days for holidays and personal days" do
    expect {
      SyncPTO.call
    }.to change {
      Day.count
    }.from(0).to(3)

    expect(user_1.days.count).to eq(2)
    expect(user_2.days.count).to eq(1)

    monday_1, tuesday_1 = user_1.days
    expect(monday_1).to be_pto
    expect(tuesday_1).to be_pto

    monday_2 = user_2.days.first
    expect(monday_2).to be_pto
  end

  it "marks existing days as PTO for holidays for all users" do
    monday_1 = create(:day, user: user_1, date: holiday, pto: false)
    monday_2 = create(:day, user: user_2, date: holiday, pto: false)

    expect {
      SyncPTO.call
    }.to change {
      Day.count
    }.from(2).to(3)

    expect(monday_1.reload).to be_pto
    expect(monday_2.reload).to be_pto
  end

  it "ignores events earlier than one month ago" do
    Timecop.travel(Date.new(2015, 7, 27))

    expect {
      SyncPTO.call
    }.not_to change {
      Day.count
    }
  end
end
