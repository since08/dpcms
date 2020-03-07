FactoryGirl.define do
  factory :player do
    sequence(:name) { |n| "poker_#{n}" }
    avatar File.open(Rails.root.join('spec/factories/foo.png'))
    gender 0
    country '中国'
    dpi_total_earning 200
    dpi_total_score 404
    memo '测试'
  end
end