module ApplicationHelper
  def your_kids
    current_user.kids.present? ? current_user.kids.order(:first_name) : nil
  end

  def your_friends_and_family
    current_user.following.present? ? current_user.following.order(:first_name) : nil
  end

  def create_your_first_kid
    content_tag(:h4, link_to("Add your kid's info", new_kid_path), class: 'home-create-kid' )
  end

  def current_path
    request.env['PATH_INFO']
  end

  def css_class_active_for link_path
    link_path == current_path ? "active" : "inactive"
  end
end
