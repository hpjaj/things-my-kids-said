class FriendAndFamily < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :kid
end
