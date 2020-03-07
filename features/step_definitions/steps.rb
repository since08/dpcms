# coding: utf-8

Given(/^已使用 '([^']*)'登录$/) do |value|
  user = FactoryGirl.create(:admin_user, email: value)
  login_as(user)
end

Given(/^访问 '([^']*)'$/) do |location|
  path = send(PATH_MAPPING[location])
  visit path
  page.current_path
  expect(page).to have_current_path(path)
end

Given(/^前往 '([^']*)'$/) do |location|
  path = TARGET_PATH_MAPPING[location].to_s
  visit URI.escape(path)
  expect(page).to have_current_path(path)
end

Given(/^应到达 '([^']*)'$/) do |location|
  sleep 0.3
  path = TARGET_PATH_MAPPING[location].to_s
  expect(page).to have_current_path(path)
end

When(/^在 '([^']*)' 填入 '([^']*)'$/) do |input_txt, value|
  input_id = INPUT_MAPPING[input_txt] ? INPUT_MAPPING[input_txt] : input_txt
  fill_in(input_id, with: value)
end

When(/^在不可见元素中 '([^']*)' 填入 '([^']*)'$/) do |input_txt, value|
  input_id = INPUT_MAPPING[input_txt] ? INPUT_MAPPING[input_txt] : input_txt
  page.execute_script("$('#{input_id}').val('#{value}')")
  # find(input_id, visible: false).set(value)
end

When(/^在编辑器中 '([^']*)' 填入 '([^']*)'$/) do |input_txt, value|
  page.execute_script("$('#{input_txt}').html('#{value}')")
end

When(/^在 '([^']*)' 上传图片$/) do |input_txt|
  input_id = INPUT_MAPPING[input_txt] ? INPUT_MAPPING[input_txt] : input_txt

  attach_file(input_id, Rails.root.join('spec/factories/foo.png'))
end

Given(/^点击链接 '([^']*)'$/) do |link|
  if ENV['CAPYBARA_DRIVER'] == 'chrome'
    click_link(link)
  else
    find_link(link).trigger('click')
  end
end

Given(/^点击按钮 '([^']*)'$/) do |button|
  if ENV['CAPYBARA_DRIVER'] == 'chrome'
    click_button(button)
  else
    find_button(button).trigger('click')
  end
end

Given(/^点击第一个按钮 '([^']*)'$/) do |button|
  if ENV['CAPYBARA_DRIVER'] == 'chrome'
    first(:button, button).click
  else
    first(:button, button).trigger('click')
  end

end

Given(/^点击元素 '([^']*)'$/) do |selector|
  if ENV['CAPYBARA_DRIVER'] == 'chrome'
    first(selector).click
  else
    first(selector).click
  end
end

Given(/^'([^']*)' 该选择器的值应为 '([^']*)'$/) do |selector, value|
  expect(first(selector).value).to eq(value)
end

Given /^点击按钮或链接 '([^']*)'$/ do |link_button|
  if ENV['CAPYBARA_DRIVER'] == 'chrome'
    find(:link_or_button, link_button).click
  else
    find(:link_or_button, link_button).trigger('click')
  end
end

Given(/^对话框中点击 '([^']*)'$/) do |text|
  accept_confirm(text)
end

Given(/^确定alert$/) do
  accept_alert
end

Given(/^等待 ([^']*) 秒$/) do |second|
  sleep(second.to_f)
end

Given(/^'([^']*)' 应看到 '([^']*)'$/) do |element, value|
  element_id = ELEMENT_MAPPING[element]
  find_by_id(element_id).should have_content(value)
end

Given(/^应该能找到 '([^']*)' 这些信息$/) do |elements|
  elements.split(',').each do |element|
    expect(page).to have_content(element)
  end
end

Given(/^在'([^']*)' 的第一个下拉框选择 '([^']*)'$/) do |id, text|
  sleep(0.3)
  first(:select, id).find(:option, text).select_option
end

Then(/^列表中应只有 '([^']*)' 条数据$/) do |number|
  expect(first('tbody').all('tr').size).to eq(number.to_i)
end

Given(/^不勾选 '([^']*)'$/) do |text|
  uncheck(text)
end

Then(/^应有提示暂无相应内容$/) do
  expect(page).to have_css('.blank_slate_container .blank_slate')
end

Then(/^应得到错误提示 '([^']*)'$/) do |text|
  expect(find('.flash_error')).to have_text(text)
end

Then(/^应得到成功提示 '([^']*)'$/) do |text|
  expect(find('.flashes')).to have_text(text)
end

When(/^表单应提醒不能为空 '([^']*)'$/) do |id|
  sleep 0.2
  @form = find_by_id(id)
  expect(@form).to have_text('不能为空')
end

When(/^表单应提醒'([^']*)' '([^']*)'$/) do |text, id|
  @form = find_by_id(id)
  expect(@form).to have_text(text)
end