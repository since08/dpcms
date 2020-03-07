FactoryGirl.define do
  factory :race_blind do
    association :race
    sequence(:level) { |n| n }
    sequence(:small_blind) { |n| 100*n }
    sequence(:big_blind)   { |n| 1000*n }
  end
end
