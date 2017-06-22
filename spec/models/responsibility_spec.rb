describe Responsibility do
  context "validations" do
    subject(:responsibility) { Responsibility.new }

    describe "title" do
      it { is_expected.to accept_values_for(:title, "Client") }
      it { is_expected.not_to accept_values_for(:title, nil, " ") }

      it "must be unique" do
        create(:responsibility, title: "Client")

        expect(responsibility).to accept_values_for(:title, "Internal")
        expect(responsibility).not_to accept_values_for(:title, "Client")
      end
    end

    describe "adjective" do
      it { is_expected.to accept_values_for(:adjective, "client") }
      it { is_expected.not_to accept_values_for(:adjective, nil, " ") }

      it "must be unique" do
        create(:responsibility, adjective: "client")

        expect(responsibility).to accept_values_for(:adjective, "internal")
        expect(responsibility).not_to accept_values_for(:adjective, "client")
      end
    end

    describe "harvest_client_ids" do
      it { is_expected.to accept_values_for(:harvest_client_ids, %w(1 2 3)) }
      it { is_expected.not_to accept_values_for(:harvest_client_ids, nil, []) }
    end

    describe "#only_one_default_may_exist" do
      it "ensures only one responsibility may be the default" do
        responsibility_1 = build(:responsibility, :default)
        expect(responsibility_1).to be_valid

        responsibility_2 = build(:responsibility, :default)
        expect(responsibility_2).to be_valid

        responsibility_1.save!
        expect(responsibility_2).to be_invalid
      end

      it "allows for no default responsibility" do
        responsibility = build(:responsibility, :not_default)
        expect(responsibility).to be_valid
      end
    end
  end

  context "callbacks" do
    describe "clear_harvest_client_ids" do
      it "clears harvest_client_ids for the default responsibility" do
        responsibility = create(:responsibility, harvest_client_ids: %w(1 2 3))

        expect {
          responsibility.update!(default: true)
          responsibility.reload
        }.to change {
          responsibility.harvest_client_ids
        }.from(%w(1 2 3)).to([])
      end
    end
  end
end
