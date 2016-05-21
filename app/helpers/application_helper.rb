module ApplicationHelper
  def your_kids
    current_user.kids.present? ? current_user.kids.order(:first_name) : nil
  end

  def your_friends_and_family
    current_user.following.present? ? current_user.following.order(:first_name) : nil
  end
end
