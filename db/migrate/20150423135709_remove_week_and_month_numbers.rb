class RemoveWeekAndMonthNumbers < ActiveRecord::Migration
  class Month < ActiveRecord::Base
  end

  class Day < ActiveRecord::Base
  end

  def up
    remove_column :days, :month_number
    remove_column :days, :week_number

    add_column :months, :year, :integer
    add_column :months, :temporary_number, :integer

    Month.find_each do |month|
      if match = month.number.match(/\A(\d{4})(\d{2})\z/)
        year, temporary_number = match.captures.map(&:to_i)
        month.update!(year: year, temporary_number: temporary_number)
      else
        raise "hell"
      end
    end

    remove_column :months, :number

    change_column_null :months, :year, false
    change_column_null :months, :temporary_number, false

    rename_column :months, :temporary_number, :number

    add_index :months, :year
    add_index :months, :number
  end

  def down
    add_column :days, :month_number, :string
    add_column :days, :week_number, :string

    Day.find_each do |day|
      month_number = day.date.strftime("%Y%m")
      week_number = day.date.strftime("%G%V")
      day.update!(month_number: month_number, week_number: week_number)
    end

    change_column_null :days, :month_number, false
    change_column_null :days, :week_number, false

    add_index :days, :month_number
    add_index :days, :week_number

    add_column :months, :temporary_number, :string

    Month.find_each do |month|
      temporary_number = "#{month.year}#{month.number.to_s.rjust(2, "0")}"
      month.update!(temporary_number: temporary_number)
    end

    remove_column :months, :year
    remove_column :months, :number

    change_column_null :months, :temporary_number, false

    rename_column :months, :temporary_number, :number

    add_index :months, :number
  end
end
