module ApplicationHelper
  def your_kids
    current_user.kids.present? ? current_user.kids : nil
  end
end
