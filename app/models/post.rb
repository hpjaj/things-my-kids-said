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
    parents = self.parents_can_see(user)
    family  = self.friends_family_can_see(user)
    all     = (parents + family).uniq

    all.sort_by { |quote| quote.created_at }.reverse!
  end

  def self.parents_can_see(user)
    kid_ids = user.kids.pluck(:id)

    self.where('kid_id in (?)', kid_ids)
  end

  def self.friends_family_can_see(user)
    kid_ids = user.following.pluck(:id)

    self
      .where('kid_id in (?)', kid_ids)
      .where(parents_eyes_only: false)
  end

  def self.user_can_see_for(kid, user)
    if user.kids.pluck(:id).include?(kid.id)
      kid.posts
    else
      kid.posts.where(parents_eyes_only: false)
    end
  end
end
