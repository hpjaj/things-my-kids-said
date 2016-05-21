class Kid < ActiveRecord::Base
  BOY  = 'boy'
  GIRL = 'girl'

  has_and_belongs_to_many :users
  has_many :posts

  has_many :friend_and_families, dependent: :destroy
  has_many :followers, through: :friend_and_families, source: :follower

  validates :first_name, presence: true
  validates :last_name, presence: true

  def parents
    users
  end
end
