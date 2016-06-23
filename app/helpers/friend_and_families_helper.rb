module FriendAndFamiliesHelper

  def yes_or_no(boolean)
    boolean ? 'Yes' : 'No'
  end

  def friends_name(friend)
    User.find(friend.follower_id).full_name
  end

  def kids_name(friend)
    Kid.find(friend.kid_id).first_name.titleize
  end

  def all_kids_have_said(current_user)
    all_kids = current_user.kids

    if all_kids.count == 1
      all_kids.first.first_name.titleize + "has said"
    elsif all_kids.count == 2
      "#{all_kids.first.first_name.titleize} and #{all_kids.first.first_name.titleize} have said"
    elsif all_kids.count > 2
      all_kids = all_kids.to_a
      last_kid = all_kids.pop
      preamble = ""

      all_kids.each do |kid|
        preamble << "#{kid.first_name.titleize}, "
      end

      preamble + "and #{last_kid.first_name.titleize} have said"
    end
  end

end
