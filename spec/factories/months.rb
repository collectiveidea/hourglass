FactoryGirl.define do
  factory :month do
    transient do
      date { Date.current }
    end

    user
    year { date.year }
    number { date.month }
  end
end
