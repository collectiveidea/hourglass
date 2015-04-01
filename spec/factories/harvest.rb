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
end
