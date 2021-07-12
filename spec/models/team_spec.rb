RSpec.describe Team do
  context "validations" do
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

  describe "#update_project_name" do
    let(:harvest) { double(Harvest::HardyClient) }
    let(:harvest_projects) { double(Harvest::API::Projects) }
    let(:harvest_project) { create(:harvest_project) }

    before do
      allow(Harvest).to receive(:hardy_client).with(
        subdomain: ENV["HARVEST_SUBDOMAIN"],
        username: ENV["HARVEST_USERNAME"],
        password: ENV["HARVEST_PASSWORD"]
      ) { harvest }

      allow(harvest).to receive(:projects).with(no_args) { harvest_projects }

      allow(harvest_projects).to receive(:find)
        .with(harvest_project.id) { harvest_project }
    end

    it "updates the Harvest project name" do
      team = create(:team, project_id: harvest_project.id)

      expect {
        team.update_project_name
      }.to change {
        team.project_name
      }.to(harvest_project.name)
    end
  end
end
