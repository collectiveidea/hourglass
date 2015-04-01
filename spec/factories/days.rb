FactoryGirl.define do
  factory :day do
    user
    date { Date.current }
  end
end
