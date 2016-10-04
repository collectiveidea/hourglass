FactoryGirl.define do
  factory :team do
    name "News Team"
    hours 80
    project_id 10
    project_name "Test Project"

    trait :active

    trait :inactive do
      active false
    end

    trait :archived do
      inactive
    end
  end
end
