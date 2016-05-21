class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  has_and_belongs_to_many :kids

  has_many :friend_and_families, foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :friend_and_families, source: :kid

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
end
