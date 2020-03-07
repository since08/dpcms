Given /^访问资讯类别管理页 创建数据$/ do
  FactoryGirl.create(:info_type)
  visit admin_info_types_path
end