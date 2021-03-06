module ApplicationHelper
  def your_kids
    current_user.kids.present? ? current_user.kids.order(:first_name) : nil
  end

  def your_friends_and_family
    current_user.following.present? ? current_user.following.order(:first_name) : nil
  end

  def help_getting_started
    controller.redirect_to help_path
  end

  def current_path
    request.env['PATH_INFO']
  end

  def css_class_active_for link_path
    link_path == current_path ? "active" : "inactive"
  end
end
