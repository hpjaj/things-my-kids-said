class Kid < ActiveRecord::Base
  BOY  = 'boy'
  GIRL = 'girl'

  has_and_belongs_to_many :users
  has_many :posts

  has_many :friend_and_families, dependent: :destroy
  has_many :followers, through: :friend_and_families, source: :follower

  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthdate, presence: true
  validates :gender, presence: true
  validate :cannot_create_duplicate, on: :create

  def parents
    users
  end

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def self.users_friends_and_families_kids_that_they_can_create_posts_for(user)
    self
      .joins(:friend_and_families)
      .where(friend_and_families: { follower_id: user.id })
      .where(friend_and_families: { can_create_posts: true })
      .order(:last_name)
      .uniq
  end

  private

  def cannot_create_duplicate

  end

  def self.kid_exists?
    blah = self.where(
      birthdate:
      )
  end
end
