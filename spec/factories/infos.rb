FactoryGirl.define do
  factory :info do
    info_type
    sequence(:title) { |n| "test_#{n}" }
    date          Time.now.strftime('%Y-%m-%d')
    source_type   'author'
    source        'Timmy'
    top            false
    published      true
    description   '### **测试**'
  end
end
