Given /^前端用户已登录$/ do
  user = FactoryGirl.create(:user_with_extra)
  request_data = DpApiRemote.post 'login', type: 'email',
                                           email: user.email,
                                           password: 'cc03e747a6afbbcbf8be7668acfebee5'
  @login_result = request_data.parsed_body
  p @login_result
  expect(@login_result['code']).to eq(0)
  expect(@login_result['data']['user_id']).to eq(user.user_uuid)
  expect(@login_result['data']['email']).to eq(user.email)
end