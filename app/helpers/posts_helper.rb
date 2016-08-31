module PostsHelper
  def timing_choices
    now        = Date.current
    yesterday  = now - 1.day
    this_week  = now.beginning_of_week
    last_week  = this_week - 1.week
    last_month = now.beginning_of_month - 1.month

    [
      ['Today', "#{now}"],
      ['Yesterday', "#{yesterday}"],
      ['This week', "#{this_week}"],
      ['Last week', "#{last_week}"],
      ['Last month', "#{last_month}"],
      ['Custom', 'custom_age']
    ]
  end

  def users_kids(current_user)
    current_user.kids +
    Kid.users_friends_and_families_kids_that_they_can_create_posts_for(current_user)
  end

  def highlight_kids_quote(post)
    quote = post.body

    quote.gsub!(/<{3}/, "<span class='#{kids_gender(post.kid)}-quote'>")
    quote.gsub!(/>{3}/, "</span>")

    simple_format(quote, class: "card-text")
  end

  def headline(post)
    "#{post_date_said(post)}, when #{post_age_said(post)}"
  end

  def post_age_said(post)
    "#{post.kid.first_name.titleize} was #{age_in_words(post)}…"
  end

  def post_show_age_said(post)
    kid = post.kid

    link_to(post.kid.first_name.titleize, kid_posts_path(kid.id), class: "#{kids_gender(kid)}-link")
    .concat(" was #{age_in_words(post)}…")
  end

  def post_date_said(post)
    "Around #{display_date post.date_said}"
  end

  def kids_current_age(kid)
    Age.new(kid.birthdate, Date.today).calculate_for_profile
  end

  def kids_birthday(kid)
    kid.birthdate.strftime("%b %e, %Y")
  end

  def friendly_name(author, kid)
    if family_name = FriendAndFamily.relationship_name_for(author, kid)
      family_name.titleize
    elsif author.parent_of?(kid) && author.parent_name.present?
      author.parent_name.titleize
    else
      author.first_name.titleize
    end
  end

  def save_button
    button_tag "Save",
      id: 'post-submit-button',
      class: 'pull-right btn solid-button devise-buttons',
      data: { disable_with: "<i class='fa fa-spinner fa-spin'></i> Saving..." }
  end

  private

  def kids_gender(kid)
    kid.gender == Kid::GIRL ? 'girl' : 'boy'
  end

  def age_in_words(post)
    Age.new(post.kid.birthdate, post.date_said).calculate
  end

  def display_date(date)
    if date.year == Date.current.year
      date.strftime("%b %e")
    else
      date.strftime("%b %e, %Y")
    end
  end

  def comment_link_and_count(post)
    count = post.comments.count

    if count == 0
      "Comment"
    else
      "Comments (#{count})"
    end
  end
end
