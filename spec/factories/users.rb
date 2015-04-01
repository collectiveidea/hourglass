FactoryGirl.define do
  factory :user do
    name "John"
    email "john@example.com"
    harvest_id { SecureRandom.uuid }
    zenefits_name { %(John "#{SecureRandom.uuid}" Doe) }
    time_zone "UTC"
  end
end
