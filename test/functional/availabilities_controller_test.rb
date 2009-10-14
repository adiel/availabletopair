require 'test_helper'

class AvailabilitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:availabilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create availability" do
    assert_difference('Availability.count') do
      post :create, :availability => { }
    end

    assert_redirected_to availability_path(assigns(:availability))
  end

  test "should show availability" do
    get :show, :id => availabilities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => availabilities(:one).to_param
    assert_response :success
  end

  test "should update availability" do
    put :update, :id => availabilities(:one).to_param, :availability => { }
    assert_redirected_to availability_path(assigns(:availability))
  end

  test "should destroy availability" do
    assert_difference('Availability.count', -1) do
      delete :destroy, :id => availabilities(:one).to_param
    end

    assert_redirected_to availabilities_path
  end
end
