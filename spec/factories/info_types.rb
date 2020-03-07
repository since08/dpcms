FactoryGirl.define do
  factory :info_type do
    sequence(:name) { |n| "新闻_#{n}" }
    published  true
  end
end
