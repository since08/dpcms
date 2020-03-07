Then(/^应该成功创建一条资讯$/) do
  sleep(0.3)
  new = Info.first
  expect(new.title).to eq('澳洲赛')
  expect(new.image_thumb).to be_truthy
end

Given(/^访问资讯管理页 创建资讯为未发布状态$/) do
  FactoryGirl.create(:info, { published: false })
  visit admin_infos_path
end

Given(/^访问资讯管理页 创建资讯为发布状态$/) do
  FactoryGirl.create(:info, { published: true })
  visit admin_infos_path
end

Given(/^访问资讯管理页 创建资讯为发布已置顶状态$/) do
  FactoryGirl.create(:info, { published: true, top: true })
  visit admin_infos_path
end

Then(/^资讯状态应该变成未发布未置顶$/) do
  sleep 0.3
  new = Info.first
  expect(new.published).to be_falsey
  expect(new.top).to be_falsey
end

Then(/^资讯状态应该变成已发布已置顶$/) do
  sleep 0.3
  new = Info.first
  expect(new.published).to be_truthy
  expect(new.top).to be_truthy
end

Then(/^数据库资讯数目为0$/) do
  sleep 0.3
  nums = Info.count
  expect(nums).to eq(0)
end
