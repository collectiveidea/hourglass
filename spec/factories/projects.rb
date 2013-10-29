FactoryGirl.define do
  factory :project do
    sequence(:name) { |i| "Project ##{i}" }
    sequence(:harvest_id)
    expected_weekly_hours 100
  end
end
