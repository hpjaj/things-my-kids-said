module PostsHelper
  def timing_choices
    now        = Date.current
    this_week  = now.beginning_of_week
    last_week  = this_week - 1.week
    last_month = now.beginning_of_month - 1.month

    [
      ['This week', "#{this_week}"],
      ['Last week', "#{last_week}"],
      ['Last month', "#{last_month}"],
      ['Custom', 'custom_age']
    ]
  end

  def users_kids(current_user)
    current_user.kids
  end

  def highlight_kids_quote(quote)
    quote.gsub!(/<{3}/, "<span class='kid-quote'>")
    quote.gsub!(/>{3}/, "</span>")

    simple_format(quote, class: "card-text")
  end

  def headline(post)
    age_in_words = Age.new(post.kid.birthdate, post.date_said).calculate

    "Around #{display_date post.date_said}, when #{post.kid.name.titleize} was #{age_in_words}…"
  end

  private

  def display_date(date)
    if date.year == Date.current.year
      date.strftime("%b %e")
    else
      date.strftime("%b %e, %Y")
    end
  end

end
