require "spec_helper"

describe FetchWeek do
  before do
    FetchTotals.stub(:perform)
  end

  describe ".perform" do
    it "fetches each day of this week" do
      Timecop.freeze(Time.zone.local(2013, 11, 14, 14, 48, 30))

      expect(FetchDay).not_to receive(:perform).with(Date.new(2013, 11, 10))
      expect(FetchDay).to receive(:perform).once.with(Date.new(2013, 11, 11)).ordered
      expect(FetchDay).to receive(:perform).once.with(Date.new(2013, 11, 12)).ordered
      expect(FetchDay).to receive(:perform).once.with(Date.new(2013, 11, 13)).ordered
      expect(FetchDay).to receive(:perform).once.with(Date.new(2013, 11, 14)).ordered
      expect(FetchDay).not_to receive(:perform).with(Date.new(2013, 11, 15))

      FetchWeek.perform
    end

    it "fetches totals for each day of this week" do
      Timecop.freeze(Time.zone.local(2013, 11, 14, 14, 48, 30))

      expect(FetchTotals).not_to receive(:perform).with(Date.new(2013, 11, 10))
      expect(FetchTotals).to receive(:perform).once.with(Date.new(2013, 11, 11)).ordered
      expect(FetchTotals).to receive(:perform).once.with(Date.new(2013, 11, 12)).ordered
      expect(FetchTotals).to receive(:perform).once.with(Date.new(2013, 11, 13)).ordered
      expect(FetchTotals).to receive(:perform).once.with(Date.new(2013, 11, 14)).ordered
      expect(FetchTotals).not_to receive(:perform).with(Date.new(2013, 11, 15))

      FetchWeek.perform
    end
  end
end
