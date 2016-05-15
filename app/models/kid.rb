class Kid < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :posts

  has_many :friend_and_families, dependent: :destroy
  has_many :followers, through: :friend_and_families, source: :follower

  def parents
    users
  end
end
