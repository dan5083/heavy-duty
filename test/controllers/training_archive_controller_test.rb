require "test_helper"

class TrainingArchiveControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get training_archive_index_url
    assert_response :success
  end
end
