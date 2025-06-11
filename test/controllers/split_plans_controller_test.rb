require "test_helper"

class SplitPlansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get split_plans_index_url
    assert_response :success
  end

  test "should get show" do
    get split_plans_show_url
    assert_response :success
  end

  test "should get new" do
    get split_plans_new_url
    assert_response :success
  end

  test "should get create" do
    get split_plans_create_url
    assert_response :success
  end

  test "should get edit" do
    get split_plans_edit_url
    assert_response :success
  end

  test "should get update" do
    get split_plans_update_url
    assert_response :success
  end

  test "should get destroy" do
    get split_plans_destroy_url
    assert_response :success
  end
end
