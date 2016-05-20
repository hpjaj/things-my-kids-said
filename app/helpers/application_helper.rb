module ApplicationHelper
  def your_kids
    current_user.kids.count > 0 ? current_user.kids : nil
  end
end
