require 'faker'

Post.destroy_all
Kid.destroy_all
User.destroy_all


john = User.create(
  email: 'john@example.com',
  first_name: 'John',
  last_name: 'Smith',
  password: 'password',
  password_confirmation: 'password'
  )

tommy = Kid.create(
  name: 'Tommy',
  birthdate: Faker::Date.between(7.years.ago, 18.months.ago),
  gender: 'boy'
  )

tommy.parents << john

30.times do
  Post.create(
    body: Faker::Hipster.paragraphs(2, true).join("\n\n"),
    user_id: john.id,
    kid_id: tommy.id,
    kids_age: "#{Faker::Number.between(1, 7)} years #{Faker::Number.between(0, 11)} months old"
  )
end


p "Seed finished"
p "#{User.count} users"
p "#{Kid.count} kids"
p "#{Post.count} posts"
