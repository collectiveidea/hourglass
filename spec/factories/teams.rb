FactoryGirl.define do
  factory :team do
    name "News Team"
    hours 80

    trait :active

    trait :inactive do
      active false
    end

    trait :archived do
      inactive
    end
  end
end
