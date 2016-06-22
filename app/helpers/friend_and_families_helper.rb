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
end
