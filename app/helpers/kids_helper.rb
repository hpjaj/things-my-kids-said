module KidsHelper
  def determine_created_by(kid, current_user)
    if kid.created_by.present?
      kid.created_by.to_s
    else
      current_user.id.to_s
    end
  end
end
