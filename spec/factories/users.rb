FactoryGirl.define do
  factory :user do
    name "John"
    email { "john.#{SecureRandom.hex}@example.com" }
    harvest_id { SecureRandom.uuid }
    zenefits_name { %(John "#{SecureRandom.uuid}" Doe) }
    time_zone "UTC"
    slack_id { "U#{SecureRandom.random_number(10_000_000_000)}" }

    trait :active

    trait :inactive do
      active false
    end

    trait :archived do
      inactive
    end
  end
end
