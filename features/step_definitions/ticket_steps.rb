# coding: utf-8
Given(/^调用api 应成功获取该票务详情/) do
  step '前端用户已登录'
  user = @login_result['data']
  race   = Race.first
  params = {token: user['access_token']}
  result = DpApiRemote.get("races/#{race.id}/tickets", params).parsed_body
  puts result['msg']
  expect(result['code']).to   eq(0)
  race_hash = result['data']['race']
  tickets = result['data']['tickets']
  expect(race_hash['race_id']).to  eq(race.id)
  expect(race_hash['name']).to     eq(race.name)
  expect(tickets.size).to eq(2)
  ticket = race.tickets[1]
  expect(tickets[1]['title']).to eq(ticket.title)
  expect(tickets[1]['title']).to eq('飞机票 + 017APT启航站主票')
  expect(tickets[1]['price']).to eq(ActiveSupport::NumberHelper::number_to_delimited ticket.price)
end


Given(/^应创建了对应的英文票务$/) do
  race = Race.last
  ticket = race.tickets[1]
  expect(ticket.title).to eq('飞机票 + 017APT启航站主票')
  expect(ticket.description).to eq('中国澳门')
  ticket_en = ticket.ticket_en
  expect(ticket_en.title).to eq('air ticket and event ticket')
  expect(ticket_en.description).to eq('macau, china')
end

Given(/^英文票务与中文票务的价格应一致，都应为 '([^']*)'$/) do |value|
  sleep 0.3
  ticket = Ticket.last
  ticket_en = ticket.ticket_en
  expect(ticket.price).to eq(ticket_en.price)
  expect(ticket.original_price).to eq(ticket_en.original_price)
  expect(ticket.price).to             eq(value.to_i)
  expect(ticket.original_price).to    eq(value.to_i)
  expect(ticket_en.price).to          eq(value.to_i)
  expect(ticket_en.original_price).to eq(value.to_i)
end