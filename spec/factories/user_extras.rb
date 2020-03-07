FactoryGirl.define do
  factory :user_extra do
    association :user
    real_name         '王石'
    cert_type         'chinese_id'
    sequence(:cert_no) { |n| "61100219930114681#{n}" }
    memo              '身份证'
    status            'init'
  end
end