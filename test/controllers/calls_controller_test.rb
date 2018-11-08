require 'test_helper'

class CallsControllerTest < ActionDispatch::IntegrationTest
  test "should get reply" do
    get calls_reply_url
    assert_response :success
  end

end
