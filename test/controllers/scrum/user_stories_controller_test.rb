require 'test_helper'

class Scrum::UserStoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scrum_user_stories_index_url
    assert_response :success
  end

end
