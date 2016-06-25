class Post < ActiveRecord::Base

  attr_accessor :years_old, :months_old, :kids_age

  belongs_to :user
  belongs_to :kid
  has_many :comments, dependent: :destroy

  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

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
