# coding: utf-8
Given(/^访问赛事盲注结构 创建数据$/) do
  @race  = FactoryGirl.create(:whole_race, published: true)
  FactoryGirl.create(:race_blind, race: @race)
  visit admin_race_race_blinds_path(@race)
  sleep 0.05
end