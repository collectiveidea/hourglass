module Dom
  class Project < Domino
    selector ".project"

    attribute :name
    attribute :harvest_id, &:to_i
    attribute :expected_weekly_hours, &:to_i
  end
end
