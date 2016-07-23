class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  has_many :filtered_kids, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :kids

  has_many :friend_and_families, foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :friend_and_families, source: :kid

  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png", preserve_files: true
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def self.potential_friends_and_family_members_of(parent)
    parent_ids = []

    parent.kids.each do |kid|
      parent_ids << kid.parents.pluck(:id)
    end

    self.where.not(id: parent_ids.uniq).order(:last_name)
  end

  def self.potential_spouse_of(parent)
    self.where.not(id: parent.id).order(:last_name)
  end

  def self.all_emails
    pluck(:email)
  end

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def fellow_parent_s
    kids    = self.kids
    spouses = []

    kids.each do |kid|
      kid.parents.each do |parent|
        next if parent == self

        spouses << parent
      end
    end

    spouses.uniq
  end

  def admin?
    role == 'admin'
  end

end
