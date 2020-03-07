FactoryGirl.define do
  factory :race_rank do
    association :race
    association :player
    sequence(:ranking) { |n| n }
    sequence(:earning) { |n| 10000/n }
    sequence(:score)   { |n| 1000/n }
  end
end
