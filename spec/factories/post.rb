FactoryGirl.define do
  factory :post do
    body  'Is that a baffroom?'
    user
    kid
    date_said 25.months.ago.to_date
    visible_to Visibility::FRIENDS

    trait :for_parents do
      visible_to Visibility::PARENTS_ONLY
    end

    trait :for_public do
      visible_to Visibility::PUBLIC
    end

    trait :for_me do
      visible_to Visibility::ME_ONLY
    end
  end
end
