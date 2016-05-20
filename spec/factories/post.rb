FactoryGirl.define do
  factory :post do
    body  'Is that a baffroom?'
    user
    kid
    date_said 25.months.ago.to_date
  end
end
