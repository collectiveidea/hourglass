RSpec.describe Team do
  subject(:team) { Team.new }

  describe "name" do
    it { is_expected.to accept_values_for(:name, "Devs") }
    it { is_expected.not_to accept_values_for(:name, nil) }
  end

  describe "hours" do
    it { is_expected.to accept_values_for(:hours, 100) }
    it { is_expected.not_to accept_values_for(:hours, nil) }
    it { is_expected.not_to accept_values_for(:hours, -100) }
  end
end
