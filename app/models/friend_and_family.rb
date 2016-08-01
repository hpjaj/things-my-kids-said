class FriendAndFamily < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :kid

  validates :kid_id, presence: true
  validates :follower_id, presence: true
  validates :follower_id, uniqueness: { scope: [:kid_id, :follower_id], message: 'This friend/family member already has access to this kid' }

  def self.parents_kids_friends_and_family(parent)
    kids_ids = parent.kids.pluck(:id)

    self
      .where(kid_id: kids_ids)
      .joins(:follower)
      .order('users.last_name')
      .order('users.first_name')
  end

  def self.relationship_name_for(follower, kid)
    self
      .where(kid_id: kid.id, follower_id: follower.id)
      .where.not(relationship_name: nil)
      .first
      .try(:relationship_name)
  end

end
