# coding: utf-8
Given(/^应创建第一个主赛的边赛成功$/) do
  sleep 0.3
  main_race = Race.first
  sub_race = main_race.sub_races.first
  expect(page).to have_current_path(admin_race_sub_race_path(main_race, sub_race))
end

Given(/^创建数据 创建第一个边赛$/) do
  main_race = FactoryGirl.create(:whole_race, published: true)
  sub_race =  FactoryGirl.create(:whole_race, parent: main_race)
  expect(sub_race.parent_id).to eq(main_race.id)
end