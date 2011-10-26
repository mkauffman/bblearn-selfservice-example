require 'test_helper'

class CAManagementsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ca_managements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ca_management" do
    assert_difference('CAManagement.count') do
      post :create, :ca_management => { }
    end

    assert_redirected_to ca_management_path(assigns(:ca_management))
  end

  test "should show ca_management" do
    get :show, :id => ca_managements(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => ca_managements(:one).to_param
    assert_response :success
  end

  test "should update ca_management" do
    put :update, :id => ca_managements(:one).to_param, :ca_management => { }
    assert_redirected_to ca_management_path(assigns(:ca_management))
  end

  test "should destroy ca_management" do
    assert_difference('CAManagement.count', -1) do
      delete :destroy, :id => ca_managements(:one).to_param
    end

    assert_redirected_to ca_managements_path
  end
end
