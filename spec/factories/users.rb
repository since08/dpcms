FactoryGirl.define do
  factory :user do
    sequence(:user_uuid) { |n| "uuid_12345#{n}" }
    sequence(:user_name) { |n| "Test#{n}" }
    sequence(:nick_name) { |n| "Test#{n}" }
    gender 2
    password_salt 'abcdef'
    password ::Digest::MD5.hexdigest('cc03e747a6afbbcbf8be7668acfebee5abcdef') # 密码是test123
    sequence(:mobile, 1000) { |n| "1801800#{n}" }
    sequence(:email) { |n| "person#{n}@deshpro.com" }
    reg_date 1.week.ago
    last_visit Time.now

    factory :user_with_extra do
      after(:create) do |user|
        FactoryGirl.create(:user_extra, user: user)
      end
    end
  end
end