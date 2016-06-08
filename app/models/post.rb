class Post < ActiveRecord::Base

  attr_accessor :years_old, :months_old, :kids_age

  belongs_to :user
  belongs_to :kid
  has_many :comments, dependent: :destroy

  validates :body, presence: true
  validates :kid_id, presence: true
  validates :user_id, presence: true
  validates :date_said, presence: true

  def self.all_associated_kids_posts(user)
    kid_ids = user.following.pluck(:id) + user.kids.pluck(:id)

    self
      .where('kid_id in (?)', kid_ids)
      .order('created_at DESC')
      .uniq
  end
end
