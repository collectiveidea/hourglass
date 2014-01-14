# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :date_total do
    date "2014-01-13"
    billable_hours "9.99"
  end
end
