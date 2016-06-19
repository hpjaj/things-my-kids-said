FactoryGirl.define do
  factory :kid do
    first_name 'Janie'
    last_name 'Smith'
    birthdate '2010-04-16'
    gender 'female'
    users { [FactoryGirl.create(:user)] }
    created_by 999999999   ##TODO - figure out how to change this to the user's id from the above line
  end
end


# To specify a certain user when creating a kid
# user = create(:user)
# kid  = create(:kid, :users => [user])

# from: http://stackoverflow.com/questions/1484374/how-to-create-has-and-belongs-to-many-associations-in-factory-girl
