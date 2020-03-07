FactoryGirl.define do
  factory :race do
    sequence(:name) { |n| "2017APT启航站第#{n}场" }
    logo File.open(Rails.root.join('spec/factories/foo.png'))
    sequence(:prize) { |n| "100_000_#{n}" }
    sequence(:location) { |n| "澳门_#{n}" }
    ticket_price 10_000
    sequence(:begin_date) { Random.rand(1..9).days.since.to_date }
    sequence(:end_date)   { Random.rand(11..19).days.since.to_date }
  end

  factory :whole_race, parent: :race do
    after(:create) do |race|
      FactoryGirl.create(:race_desc, race: race)
      ticket =  FactoryGirl.create(:ticket, race: race, status: 'selling')
      FactoryGirl.create(:ticket_info, ticket: ticket)
    end
  end
end
