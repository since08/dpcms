require 'test_helper'

class Scrum::AcsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scrum_acs_index_url
    assert_response :success
  end

end
