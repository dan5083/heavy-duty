require "test_helper"

class WorkoutLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get workout_logs_new_url
    assert_response :success
  end

  test "should get create" do
    get workout_logs_create_url
    assert_response :success
  end

  test "should get show" do
    get workout_logs_show_url
    assert_response :success
  end

  test "should get index" do
    get workout_logs_index_url
    assert_response :success
  end
end
