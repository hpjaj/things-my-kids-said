class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :kid

  validates :body, presence: true
  validates :kid_id, presence: true
  validates :user_id, presence: true
  validates :kids_age, presence: true
end
