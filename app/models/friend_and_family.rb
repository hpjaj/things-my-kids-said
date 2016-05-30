class FriendAndFamily < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :kid

  validates :kid_id, presence: true
  validates :follower_id, presence: true
  validates :follower_id, uniqueness: { scope: [:kid_id, :follower_id], message: 'This friend/family member already has a permission for this kid' }
  validate :cannot_create_duplicate_records, on: :create

  def self.parents_kids_friends_and_family(parent)
    kids_ids = parent.kids.pluck(:id)

    self
      .where(kid_id: kids_ids)
      .joins(:follower)
      .order('users.last_name')
      .order('users.first_name')
  end

  private

  def cannot_create_duplicate_records
    if FriendAndFamily.where(kid_id: self.kid_id, follower_id: self.follower_id).present?
      errors.add(:follower_id, "This friend/family member already has a permission for this kid")
    end
  end

end
