class TeamDay
  attr_reader :date, :client_hours, :internal_hours

  def initialize(date:, client_hours:, internal_hours:)
    @date = date
    @client_hours = client_hours
    @internal_hours = internal_hours
  end

  def self.for_date_range(date_range)
    days = Day.where(date: date_range).order(:date)

    days.group_by(&:date).map do |date, date_days|
      new(
        date: date,
        client_hours: date_days.sum(&:client_hours),
        internal_hours: date_days.sum(&:internal_hours)
      )
    end
  end
end
