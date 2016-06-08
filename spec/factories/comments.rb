FactoryGirl.define do
  factory :comment do
    user nil
    post nil
    body "MyText"
  end
end
