require "test_helper"

class SplitDaysControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get split_days_show_url
    assert_response :success
  end

  test "should get edit" do
    get split_days_edit_url
    assert_response :success
  end

  test "should get update" do
    get split_days_update_url
    assert_response :success
  end
end
