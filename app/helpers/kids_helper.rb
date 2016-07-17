module KidsHelper
  def determine_created_by(kid, current_user)
    if kid.created_by.present?
      kid.created_by.to_s
    else
      current_user.id.to_s
    end
  end

  def all_related_kids_for(user)
    kids = user.kids + user.following

    kids.sort_by { |kid| kid.last_name }
  end
end
