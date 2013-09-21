require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  setup do
    @setting = settings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create setting" do
    assert_difference('Settings.count') do
      post :create, setting: { allowed_error: @setting.allowed_error, ban_time: @setting.ban_time, last_updated: @setting.last_updated, update_time: @setting.update_time }
    end

    assert_redirected_to setting_path(assigns(:setting))
  end

  test "should show setting" do
    get :show, id: @setting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @setting
    assert_response :success
  end

  test "should update setting" do
    patch :update, id: @setting, setting: { allowed_error: @setting.allowed_error, ban_time: @setting.ban_time, last_updated: @setting.last_updated, update_time: @setting.update_time }
    assert_redirected_to setting_path(assigns(:setting))
  end

  test "should destroy setting" do
    assert_difference('Settings.count', -1) do
      delete :destroy, id: @setting
    end

    assert_redirected_to settings_index_path
  end
end
