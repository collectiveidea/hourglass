FactoryGirl.define do
  factory :day do
    project
    date { Date.current }
    hours 10
  end
end
