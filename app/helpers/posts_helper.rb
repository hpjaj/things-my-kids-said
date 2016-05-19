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

end
