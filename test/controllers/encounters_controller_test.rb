require "test_helper"

class EncountersControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get encounters_update_url
    assert_response :success
  end
end
