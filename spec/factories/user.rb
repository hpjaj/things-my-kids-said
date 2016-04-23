FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Smith"
    sequence(:email, 100) { |n| "person#{n}@example.com" }
    password "helloworld"
    password_confirmation "helloworld"
  end
end
