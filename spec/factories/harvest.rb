FactoryGirl.define do
  factory :harvest_time_entry, class: Harvest::TimeEntry do
    skip_create

    transient do
      start_time { Time.current }
    end

    client "Spacely Sprockets"
    created_at { start_time.utc.xmlschema }
    hours { hours_without_timer }
    hours_without_timer 1.23
    id { SecureRandom.random_number(1_000_000_000) }
    notes "Turning R.U.D.I on and off"
    project "R.U.D.I"
    project_id { SecureRandom.random_number(10_000_000).to_s }
    spent_at { timer_started_at.to_date }
    task "Switch Flipping"
    task_id { SecureRandom.random_number(100_000).to_s }
    timer_started_at { start_time.utc.xmlschema }
    updated_at { start_time.utc.xmlschema }
    user_id { SecureRandom.random_number(1_000_000) }

    trait :in_progress do
      hours { hours_without_timer + 1.11 }
    end

    trait :client

    trait :internal do
      client { ENV["HARVEST_INTERNAL_CLIENT"] }
    end
  end

  factory :harvest_project, class: Harvest::Project do
    skip_create

    transient do
      start_time { 1.month.ago }
    end

    active { [true, false].sample }
    bill_by { %w(project tasks people none).sample }
    billable { [true, false].sample }
    budget nil
    budget_by { bill_by }
    client_id { SecureRandom.random_number(1_000_000_000) }
    code nil
    cost_budget nil
    cost_budget_include_expenses { [true, false].sample }
    created_at { start_time.utc.xmlschema }
    ends_on nil
    estimate nil
    estimate_by { bill_by }
    hint_earliest_record_at { starts_on }
    hint_latest_record_at { Time.current.utc.to_date.to_s }
    hourly_rate nil
    id { SecureRandom.random_number(1_000_000_000) }
    is_fixed_fee { [true, false].sample }
    notes nil
    notifiy_when_over_budget { [true, false].sample }
    over_budget_notification_percentage {
      ((SecureRandom.random_number(5) + 5) * 10).to_f
    }
    over_budget_notified_at nil
    sequence(:name) { |i| "Project ##{i}" }
    starts_on { start_time.utc.to_date.to_s }
    updated_at { created_at }
  end
end
