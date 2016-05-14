class Post < ActiveRecord::Base

  attr_accessor :years_old, :months_old

  belongs_to :user
  belongs_to :kid

  validates :body, presence: true
  validates :kid_id, presence: true
  validates :user_id, presence: true
  validates :kids_age, presence: true
end
