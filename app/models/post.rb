class Post < ActiveRecord::Base

  attr_accessor :years_old, :months_old, :kids_age

  belongs_to :user
  belongs_to :kid

  validates :body, presence: true
  validates :kid_id, presence: true
  validates :user_id, presence: true
  validates :date_said, presence: true
end
