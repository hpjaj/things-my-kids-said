module ApplicationHelper
  def your_kids
    current_user.kids.present? ? current_user.kids.order(:name) : nil
  end

  def your_friends_and_family
    current_user.following.present? ? current_user.following.order(:name) : nil
  end
end
