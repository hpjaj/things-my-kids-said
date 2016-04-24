class Age

  def initialize(birthdate, post_created_at)
    @post_date = post_created_at.to_date
    @birthdate = birthdate
  end

  def display
    if @birthdate + 2.years > @post_date
      in_months
    elsif @birthdate + 9.years > @post_date
      in_years_and_months
    else
      in_years
    end
  end

  private

  def age_in_days
    (@post_date - @birthdate).to_i
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
