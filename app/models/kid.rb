class Kid < ActiveRecord::Base
  acts_as_paranoid

  BOY  = 'boy'
  GIRL = 'girl'

  has_and_belongs_to_many :users
  has_many :posts
  has_many :filtered_kids, dependent: :destroy
  has_many :pictures

  accepts_nested_attributes_for :pictures

  has_many :friend_and_families, dependent: :destroy
  has_many :followers, through: :friend_and_families, source: :follower

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthdate, presence: true
  validates :gender, presence: true
  validates :created_by, presence: true
  validate :cannot_create_duplicate, on: :create, if: :created_by_valid_user?

  scope :sort_by_last_name, -> { order(last_name: :asc) }

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

  def self.matching_kids(kid, parent_ids)
    self
      .joins(:users)
      .where(users: { id: parent_ids })
      .where(gender: kid.gender)
      .where(birthdate: kid.birthdate)
      .where(first_name: kid.first_name.downcase)
      .where(last_name: kid.last_name.downcase)
  end

  def self.with_ids(ids)
    self.where(id: ids)
  end

  def self.filtered_out_by(user)
    self
      .joins(:filtered_kids)
      .where(filtered_kids: { user_id: user.id })
  end

  private

  ## TODO - remove this method from here and the validation check once the spec/factories/kid.rb :created_by issue is resolved
  def created_by_valid_user?
    User.find_by(id: self.created_by)
  end

  def cannot_create_duplicate
    user           = User.find_by(id: self.created_by)
    parent_ids     = user.fellow_parent_s
    duplicate_kid  = Kid.matching_kids(self, parent_ids)

    if duplicate_kid.present?
      errors.add(:first_name, 'A kid with the same first name, last name, birthdate and gender has already been created by your spouse/partner.')
    end
  end

end
