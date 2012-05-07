require 'test_helper'

class CourseModelsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:course_models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create course_model" do
    assert_difference('CourseModel.count') do
      post :create, :course_model => { }
    end

    assert_redirected_to course_model_path(assigns(:course_model))
  end

  test "should show course_model" do
    get :show, :id => course_models(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => course_models(:one).to_param
    assert_response :success
  end

  test "should update course_model" do
    put :update, :id => course_models(:one).to_param, :course_model => { }
    assert_redirected_to course_model_path(assigns(:course_model))
  end

  test "should destroy course_model" do
    assert_difference('CourseModel.count', -1) do
      delete :destroy, :id => course_models(:one).to_param
    end

    assert_redirected_to course_models_path
  end
end
