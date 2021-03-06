class Post < ActiveRecord::Base
  acts_as_paranoid

  include PgSearch

  attr_accessor :years_old, :months_old, :kids_age

  belongs_to :user
  belongs_to :kid
  has_many :comments, dependent: :destroy
  belongs_to :picture

  accepts_nested_attributes_for :picture

  validates :body, presence: true
  validates :kid_id, presence: true
  validates :user_id, presence: true
  validates :date_said, presence: true
  validates :visible_to, presence: true

  pg_search_scope :search_by_body,
                  against: :body,
                  using: {
                    tsearch: {
                      dictionary: "english",
                      prefix: true
                    }
                  }

  def self.all_associated_kids_posts(user)
    parents = self.parents_can_see(user).filter_kids_settings(user)
    family  = self.friends_family_can_see(user).filter_kids_settings(user)
    all     = (parents + family).uniq

    all.sort_by { |quote| quote.created_at }.reverse!
  end

  def self.all_for_user_for_search(user)
    parents = self.parents_can_see(user)
    family  = self.friends_family_can_see(user)
    all     = (parents + family).uniq
  end

  def self.parents_can_see(user)
    kid_ids = user.kids.pluck(:id)

    self
      .where('(kid_id in (?) AND visible_to in (?)) OR (visible_to = ? AND user_id = ?)',
        kid_ids,
        Visibility.all_levels_without_me,
        Visibility::ME_ONLY,
        user.id
      )
  end

  def self.friends_family_can_see(user)
    kid_ids = user.following.pluck(:id)

    self
      .where('kid_id in (?)', kid_ids)
      .where('visible_to in (?) OR (visible_to = ? AND user_id = ?)',
        Visibility.friends_and_public,
        Visibility::ME_ONLY,
        user.id
      )
  end

  def self.parent_can_see_for_their_kid(kid, user)
    self
      .where('(kid_id = ? AND visible_to in (?)) OR (visible_to = ? AND user_id = ?)',
        kid.id,
        Visibility.all_levels_without_me,
        Visibility::ME_ONLY,
        user.id
      )
  end

  def self.friends_family_can_see_for_this_kid(kid, user)
    self
      .where('kid_id = ?', kid.id)
      .where('visible_to in (?) OR (visible_to = ? AND user_id = ?)',
        Visibility.friends_and_public,
        Visibility::ME_ONLY,
        user.id
      )
  end

  def self.filter_kids_settings(user)
    kid_ids = user.filtered_kids.pluck(:kid_id)

    self.where.not(kid_id: kid_ids)
  end

  def self.user_can_see_for(kid, user)
    if user.kids.pluck(:id).include?(kid.id)
      parent_can_see_for_their_kid(kid, user)
    else
      friends_family_can_see_for_this_kid(kid, user)
    end
  end

  def self.most_recent_with_photo
    self
      .where.not(photo_file_name: nil)
      .order(date_said: :desc)
      .order(created_at: :desc)
    .first
  end

  def self.most_recent_with_picture
    self
      .where.not(picture_id: nil)
      .order(date_said: :desc)
      .order(created_at: :desc)
    .first
  end

  def self.using_picture(picture_id)
    self.where(picture_id: picture_id).count
  end

  def to_param
    "#{id}-#{Kid.find(kid_id).first_name.downcase}"
  end

  def kids_name
    @kid ||= Kid.find_by(id: kid_id)

    @kid.first_name.titleize
  end

  def age_when_said
    Age.new(@kid.birthdate, date_said).calculate
  end

  def quote
    body
  end

  def captured_by
    @user ||= User.find_by(id: self.user_id)

    @user.full_name
  end

  def said_on
    date_said.strftime("%_m/%-d/%Y")
  end

  def created_on
    created_at.strftime("%_m/%-d/%Y")
  end

  def for_parents_only
    parents_eyes_only ? 'yes' : 'no'
  end

  def visibile_to_friends_and_family?
    visible_to == Visibility::FRIENDS
  end

  def author?(user)
    user_id == user.id
  end

  def self.to_csv
    attributes = %w{ kids_name said_on age_when_said quote captured_by created_on for_parents_only }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

end
