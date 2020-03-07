FactoryGirl.define do
  factory :purchase_order do
    association :race
    association :user
    email 'test@gmail.com'
    address '深圳市福田区卓越大厦'
    consignee 'xiaoming'
    price 8888
    original_price 8888
    after(:build) do |order|
      order.ticket = FactoryGirl.create(:ticket, race: order.race)
    end
  end
end
