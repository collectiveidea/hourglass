FactoryGirl.define do
  factory :month do
    transient do
      date { Date.current }
    end

    user
    number { date.strftime("%Y%m") }
  end
end
