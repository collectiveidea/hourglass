FactoryGirl.define do
  factory :day do
    user
    date { Date.current }
    workday true
  end
end
