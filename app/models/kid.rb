class Kid < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :posts

  def parents
    users
  end
end
