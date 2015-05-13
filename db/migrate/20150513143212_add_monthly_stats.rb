class AddMonthlyStats < ActiveRecord::Migration
  class Month < ActiveRecord::Base
  end

  def up
    add_column :months, :day_count, :integer, default: 0, null: false
    add_column :months, :pto_count, :integer, default: 0, null: false
    add_column :months, :timer_reminder_sent_count, :integer, default: 0, null: false
    add_column :months, :tracked_in_real_time_count, :integer, default: 0, null: false

    Month.find_each do |month|
      day_count = Date.new(month.year, month.number).end_of_month.day
      month.update_columns(day_count: day_count, updated_at: Time.current)
    end
  end

  def down
    remove_column :months, :tracked_in_real_time_count
    remove_column :months, :timer_reminder_sent_count
    remove_column :months, :pto_count
    remove_column :months, :day_count
  end
end
