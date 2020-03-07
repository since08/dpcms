# coding: utf-8
Given(/^访问赛事详情页 创建数据$/) do
  @race = FactoryGirl.create(:whole_race, published: true)
  visit admin_race_path(@race.id)
  sleep 0.05
end

Given(/^访问赛事列表页 创建数据$/) do
  FactoryGirl.create(:whole_race, published: true)
  visit admin_races_path
end

Given(/^调用api 应无法获取该赛事详情$/) do
  sleep 0.3
  race = Race.last
  result = DpApiRemote.get("u/0/races/#{race.id}")
  puts result.parsed_body
  expect(result.parsed_body['code']).to eq 1100006
end

Given(/^应创建了对应的英文赛事$/) do
  race = Race.last
  expect(race.name).not_to eq(race.race_en.name)
  expect(race.prize).to eq(race.race_en.prize)
  expect(race.logo.url.blank?).to be_falsey
  expect(race.race_en.logo.url.blank?).to be_falsey
  expect(race.race_desc.description).to eq('中国澳门')
  expect(race.race_desc_en.description).to eq('macau, china')
end

Given(/^调用api 应成功获取该赛事详情/) do
  sleep 0.3
  race = Race.first
  result = DpApiRemote.get("u/0/races/#{race.id}").parsed_body
  puts result['msg']
  expect(result['code']).to   eq(0)
  data = result['data']['race']
  expect(data['race_id']).to  eq(race.id)
  expect(data['name']).to     eq(race.name)
  expect(data['seq_id']).to   eq(race.seq_id)
  expect(data['status']).to   eq(race.status)
  # expect(data['ticket_status']).to eq(race.ticket_status)
end

Given(/^调用api 应取消售票成功/) do
  sleep 0.5
  race = Race.first
  result = DpApiRemote.get("u/0/races/#{race.id}").parsed_body
  puts result['msg']
  expect(result['code']).to   eq(0)
  data = result['data']
  expect(data['ticket_sellable']).to  eq(race.ticket_sellable)
  expect(data['ticket_sellable']).to  eq(false)
end

When(/^新增电子票 '([^']*)' 张$/) do |number|
  input_id = INPUT_MAPPING['新增电子票']
  fill_in(input_id, with: number)
  all(:button, '保存')[0].click
  accept_alert
end

When(/^减少电子票 '([^']*)' 张$/) do |number|
  input_id = INPUT_MAPPING['减少电子票']
  fill_in(input_id, with: number)
  all(:button, '保存')[1].click
  accept_alert
end

When(/^新增实体票 '([^']*)' 张$/) do |number|
  input_id = INPUT_MAPPING['新增实体票']
  fill_in(input_id, with: number)
  all(:button, '保存')[2].click
  accept_alert
end

When(/^减少实体票 '([^']*)' 张$/) do |number|
  input_id = INPUT_MAPPING['减少实体票']
  fill_in(input_id, with: number)
  all(:button, '保存')[3].click
  accept_alert
end


When(/^电子票票数应变成 '([^']*)' 张$/) do |number|
  sleep 0.5
  ticket_info = TicketInfo.last
  expect(ticket_info.e_ticket_number) .to eq(number.to_i)
end

When(/^实体票票数应变成 '([^']*)' 张$/) do |number|
  sleep 0.5
  ticket_info = TicketInfo.last
  expect(ticket_info.entity_ticket_number) .to eq(number.to_i)
end