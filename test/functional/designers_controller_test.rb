require 'test_helper'

class DesignersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sections)
  end
end
