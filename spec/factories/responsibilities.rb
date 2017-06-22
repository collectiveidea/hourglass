FactoryGirl.define do
  factory :responsibility do
    sequence(:title) { |i| "Responsibility ##{i}" }
    adjective { title.downcase }
    harvest_client_ids { Array.new(rand(3) + 1) { (rand(1_000_000) + 1).to_s } }
    sequence(:position) { |i| i }

    trait :default do
      harvest_client_ids []
      default true
    end

    trait :not_default
  end
end
