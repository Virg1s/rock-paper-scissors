require "test_helper"

class ThrowControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get throw_index_url
    assert_response :success
  end
end
