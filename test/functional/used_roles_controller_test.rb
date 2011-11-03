require 'test_helper'

class UsedRolesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:used_roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create used_role" do
    assert_difference('UsedRole.count') do
      post :create, :used_role => { }
    end

    assert_redirected_to used_role_path(assigns(:used_role))
  end

  test "should show used_role" do
    get :show, :id => used_roles(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => used_roles(:one).to_param
    assert_response :success
  end

  test "should update used_role" do
    put :update, :id => used_roles(:one).to_param, :used_role => { }
    assert_redirected_to used_role_path(assigns(:used_role))
  end

  test "should destroy used_role" do
    assert_difference('UsedRole.count', -1) do
      delete :destroy, :id => used_roles(:one).to_param
    end

    assert_redirected_to used_roles_path
  end
end
