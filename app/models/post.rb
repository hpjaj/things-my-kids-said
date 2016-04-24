class Post < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :kids

  validates :body, presence: true
end
