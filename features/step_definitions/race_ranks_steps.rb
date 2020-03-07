# coding: utf-8
Given(/^访问赛事排行榜 创建数据$/) do
  @race  = FactoryGirl.create(:whole_race, published: true)
  player = FactoryGirl.create(:player)
  FactoryGirl.create(:race_rank, race: @race, player: player)
  visit admin_race_race_ranks_path(@race)
  sleep 0.05
end