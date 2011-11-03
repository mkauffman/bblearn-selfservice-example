require 'test_helper'

class UserServiceRolesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_service_roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_service_role" do
    assert_difference('UserServiceRole.count') do
      post :create, :user_service_role => { }
    end

    assert_redirected_to user_service_role_path(assigns(:user_service_role))
  end

  test "should show user_service_role" do
    get :show, :id => user_service_roles(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => user_service_roles(:one).to_param
    assert_response :success
  end

  test "should update user_service_role" do
    put :update, :id => user_service_roles(:one).to_param, :user_service_role => { }
    assert_redirected_to user_service_role_path(assigns(:user_service_role))
  end

  test "should destroy user_service_role" do
    assert_difference('UserServiceRole.count', -1) do
      delete :destroy, :id => user_service_roles(:one).to_param
    end

    assert_redirected_to user_service_roles_path
  end
end
