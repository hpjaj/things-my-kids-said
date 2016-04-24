FactoryGirl.define do
  factory :kid do
    name 'Janie'
    birthdate '2010-04-16'
    gender 'female'
    users { [FactoryGirl.create(:user)] }
  end
end


# To specify a certain user when creating a kid
# user = create(:user)
# kid  = create(:kid, :users => [user])

# from: http://stackoverflow.com/questions/1484374/how-to-create-has-and-belongs-to-many-associations-in-factory-girl
