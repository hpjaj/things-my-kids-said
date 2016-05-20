module ApplicationHelper
  def your_kids
    current_user.kids.present? ? current_user.kids.order(:name) : nil
  end
  end
end
