require 'test_helper'

class Scrum::IterationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scrum_iterations_index_url
    assert_response :success
  end

end
