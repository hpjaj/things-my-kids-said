module ParentsHelper
  def parent_name_explanation
    "This sets the Captured by NAME for your kids' quotes (i.e. Captured by mom).  If blank, it defaults to your first name."
  end

  def can_edit_parent_name?(parent, user)
    user == parent
  end

  def parents_name(parent, user)
    if parent.parent_name.present?
      parent.parent_name.titleize
    elsif can_edit_parent_name?(parent, user)
      link_to('Edit', parent_name_path)
    end
  end

  def edit_parents_name(parent, user)
    if can_edit_parent_name?(parent, user)
      link_to('Edit', parent_name_path)
    else
      "#{parent.first_name.titleize} can edit"
    end
  end
end
