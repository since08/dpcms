FactoryGirl.define do
  factory :admin_user do
    sequence(:email) { |n| "email#{n}@deshpro.com" }
    password 'test123'
    password_confirmation 'test123'
    after(:build) do |admin|
      admin.admin_roles = [FactoryGirl.create(:admin_role)]
    end
  end

  factory :admin_role do
    name 'super admin'
    permissions CmsAuthorization.permissions
  end
end
