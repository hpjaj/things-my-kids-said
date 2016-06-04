class Age

  attr_reader :birthdate, :date_said

  def initialize(birthdate, date_said)
    @date_said = date_said.to_date
    @birthdate = birthdate
  end

  def calculate
    if birthdate + 2.years > date_said
      in_months
    elsif birthdate + 9.years > date_said
      in_years_and_months
    else
      in_years
    end
  end

  def calculate_for_profile
    if birthdate + 2.years > date_said
      in_months
    else
      in_years
    end
  end

  private

  def age_in_days
    (date_said - birthdate).to_i
  end

  def in_months
    "#{age_in_days / 30} months old"
  end

  def in_years_and_months
    age_in_years   = age_in_days / 365
    days_remaining = age_in_days % 365.0
    months         = (days_remaining / 30).to_i

    "#{age_in_years} years #{months} months old"
  end

  def in_years
    "#{age_in_days / 365} years old"
  end

end
