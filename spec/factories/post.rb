FactoryGirl.define do
  factory :post do
    body  'Is that a baffroom?'
    users { [FactoryGirl.create(:user)] }
    kids  { [FactoryGirl.create(:kid)] }
  end
end


# To specify a certain user when creating a post
# user = create(:user)
# post = create(:post, :users => [user])

# from: http://stackoverflow.com/questions/1484374/how-to-create-has-and-belongs-to-many-associations-in-factory-girl
