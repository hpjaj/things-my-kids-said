module ApplicationHelper
  def my_kids(current_user)
    kids = current_user.try(:kids)

    if kids.present? && kids.first.id.present?
      kids
    else
      false
    end
  end
end
