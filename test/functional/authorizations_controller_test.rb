require 'test_helper'

class AuthorizationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:authorizations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create authorization" do
    assert_difference('Authorization.count') do
      post :create, :authorization => { }
    end

    assert_redirected_to authorization_path(assigns(:authorization))
  end

  test "should show authorization" do
    get :show, :id => authorizations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => authorizations(:one).to_param
    assert_response :success
  end

  test "should update authorization" do
    put :update, :id => authorizations(:one).to_param, :authorization => { }
    assert_redirected_to authorization_path(assigns(:authorization))
  end

  test "should destroy authorization" do
    assert_difference('Authorization.count', -1) do
      delete :destroy, :id => authorizations(:one).to_param
    end

    assert_redirected_to authorizations_path
  end
end
