require 'faker'

Post.destroy_all
Kid.destroy_all
User.destroy_all


paula = User.create(
  email: 'paula@example.com',
  first_name: 'Paula',
  last_name: 'Levine',
  password: 'password',
  password_confirmation: 'password'
  )

harry = User.create(
  email: 'harry@example.com',
  first_name: 'Harry',
  last_name: 'Levine',
  password: 'password',
  password_confirmation: 'password'
  )

jackie = Kid.create(
  first_name: 'Jackie',
  last_name: 'Levine',
  birthdate: Date.new(2012, 10, 24),
  gender: Kid::GIRL
  )

janie = Kid.create(
  first_name: 'Janie',
  last_name: 'Levine',
  birthdate: Date.new(2010, 7, 15),
  gender: Kid::GIRL
  )

jackie.parents << paula
janie.parents << paula

jackie.parents << harry
janie.parents << harry


pam = User.create(
  email: 'pam@example.com',
  first_name: 'Pam',
  last_name: 'Levine',
  password: 'password',
  password_confirmation: 'password'
  )

min = User.create(
  email: 'min@example.com',
  first_name: 'Min',
  last_name: 'Levine',
  password: 'password',
  password_confirmation: 'password'
  )

kevin = User.create(
  email: 'kevin@example.com',
  first_name: 'Kevin',
  last_name: 'Johnson',
  password: 'password',
  password_confirmation: 'password'
  )

john = User.create(
  email: 'john@example.com',
  first_name: 'John',
  last_name: 'Smith',
  password: 'password',
  password_confirmation: 'password'
  )

susan = User.create(
  email: 'susan@example.com',
  first_name: 'Susan',
  last_name: 'Smith',
  password: 'password',
  password_confirmation: 'password'
  )

tyler = Kid.create(
  first_name: 'Tyler',
  last_name: 'Smith',
  birthdate: Date.new(2013, 4, 8),
  gender: Kid::BOY
  )

rebecca = Kid.create(
  first_name: 'Rebecca',
  last_name: 'Smith',
  birthdate: Date.new(2013, 2, 25),
  gender: Kid::GIRL
  )

brian = Kid.create(
  first_name: 'Brian',
  last_name: 'Johnson',
  birthdate: Date.new(2014, 1, 9),
  gender: Kid::BOY
  )

harry.following << tyler
harry.following << rebecca
harry.following << brian

paula.following << tyler
paula.following << rebecca
paula.following << brian

janie.followers << pam
janie.followers << min
janie.followers << kevin
janie.followers << john
janie.followers << susan

jackie.followers << pam
jackie.followers << min
jackie.followers << kevin
jackie.followers << john
jackie.followers << susan

brian.parents << kevin

tyler.parents << john
tyler.parents << susan

rebecca.parents << john
rebecca.parents << susan



FriendAndFamily.all.each { |friend| friend.update(can_create_posts: true) }


# 30.times do
#   Post.create(
#     body: Faker::Hipster.paragraphs(2, true).join("\n\n"),
#     user_id: paula.id,
#     kid_id: tommy.id,
#     date_said: Faker::Date.between(tommy.birthdate + 18.months, Date.current)
#   )
# end

# 30.times do
#   Post.create(
#     body: Faker::Hipster.paragraphs(2, true).join("\n\n"),
#     user_id: paula.id,
#     kid_id: janie.id,
#     date_said: Faker::Date.between(janie.birthdate + 18.months, Date.current)
#   )
# end


Post.create(
  body: 'Janie wanted to watch Bob the Builder because it was about architecture and she loves that. She said, <<<"mom when I grow up, I am going to be lots of things.">>> I said I know you will. You put your mind to anything and you can do it. She says, <<<"yep...follow your dreams.">>>',
  user_id: paula.id,
  kid_id: janie.id,
  date_said: Date.current,
  created_at: Date.current
)

Post.create(
  body: 'Jackie was holding a toy figure of a cow. She turned it over, pointed to the utters and said <<<"mom, look at its junk!!">>>',
  user_id: paula.id,
  kid_id: jackie.id,
  date_said: Date.current,
  created_at: Date.current
)

Post.create(
  body: "We were at a restaurant and I had to take her to the bathroom. The men’s room. We went into one of the stalls, and when we were done and leaving, we were walking by the standup toilets and Jackie stopped when she saw the stand up urinals.\r\n\r\nShe pointed at them and asked, <<<\"You wash your hands?\">>>\r\n\r\nI laughed and I said, \"No, that’s where boys go to the bathroom.\"\r\n\r\nShe thought about it for a second and then asked, <<<\"Hurts your tushie?\">>>",
  user_id: harry.id,
  kid_id: jackie.id,
  date_said: Date.current - 3.weeks,
  created_at: Date.current - 3.weeks
)

Post.create(
  body: "Janie's co-teacher Mrs. Harper told me that when they had owls come to school the instructor told them that they ate insects and rodents. Janie waved her hand up in the air and said to the class <<<\"did you know it's ok to eat insects as long as they have 6 legs or under and you roast them first?\">>> Mrs. Harper said she and Mrs. Nugent were laughing!!",
  user_id: paula.id,
  kid_id: janie.id,
  date_said: Date.current - 1.month,
  created_at: Date.current - 1.month
)

Post.create(
  body: "We were driving in the car on the way to summer camp. Janie says, <<<\"Mom, we really should have rode our bikes instead of drive our car. Cars release CO2 and bikes do not.\">>> I said, \"that would be a really long bike ride.\" She said, <<<\"That is ok. The CO2 makes our world sick.\">>>",
  user_id: paula.id,
  kid_id: janie.id,
  date_said: Date.current - 2.months,
  created_at: Date.current - 2.months
)

#######################################

Post.create(
  body: "Tyler wasn't listening very well at all tonight and I wasn't following through on my threats. Rebecca said \"mom didn't you already tell her to lower her voice?\" I said \"yes. Unfortunately mommy has told her many things tonight that I haven't dealt with.\" Tyler pipes up and says, <<<\"oh mothers...they are so cute!\">>>",
  user_id: susan.id,
  kid_id: tyler.id,
  date_said: Date.current - 18.days,
  created_at: Date.current - 18.days
)

Post.create(
  body: "Susan was giving the kids a bath, and I hear some kind of spitting noise coming from Rebecca. Then I hear Tyler say, <<<\"Becca, that is some serious beat boxing!\">>>",
  user_id: john.id,
  kid_id: tyler.id,
  date_said: Date.current - 2.days,
  created_at: Date.current - 2.days
)

Post.create(
  body: "I asked Tyler what was going on in the show he was watching. He told me that the bear is getting a tooth.\r\n\r\nI said, \"Getting a tooth or losing a tooth?\"\r\n\r\nHe said, <<<\"You'll see when you see!\">>>",
  user_id: paula.id,
  kid_id: tyler.id,
  date_said: Date.current - 2.months,
  created_at: Date.current - 2.months
)



p "Seed finished"
p "#{User.count} users"
p "#{Kid.count} kids"
p "#{Post.count} posts"
