require "spec_helper"

describe "fetch:week" do
  include_context "rake"

  before do
    FetchWeek.stub(:perform)
  end

  its(:prerequisites) { should include("environment") }

  it "fetches the week's data" do
    FetchWeek.should_receive(:perform)
    subject.invoke
  end
end

describe "fetch:today" do
  include_context "rake"

  before do
    FetchTotals.stub(:perform)
  end

  its(:prerequisites) { should include("environment") }

  it "fetches today's data" do
    FetchTotals.should_receive(:perform).with(Date.current)
    subject.invoke
  end
end