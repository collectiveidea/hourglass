FactoryGirl.define do
  factory :harvest_project, class: Harvest::Project do
    skip_create

    id { SecureRandom.random_number(1_000_000_000) }
    client_id { SecureRandom.random_number(1_000_000_000) }
    sequence(:name) { |i| "Project ##{i}" }
    code nil
    active true
    billable true
    is_fixed_fee true
    bill_by "People"
    hourly_rate 100
    budget 100
    budget_by "project"
    notify_when_over_budget true
    over_budget_notification_percentage 80
    over_budget_notified_at nil
    show_budget_to_all true
    created_at { Time.current.utc.xmlschema }
    updated_at { created_at }
    starts_on { Time.parse(created_at).to_date.to_s }
    ends_on { (Date.parse(starts_on) + 2.years).to_s }
    estimate 100
    estimate_by "project"
    hint_earliest_record_at { starts_on }
    hint_latest_record_at { Date.parse(starts_on) + rand(730).days }
    notes nil
    cost_budget nil
    cost_budget_include_expenses false
  end

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
end
