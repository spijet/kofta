require 'test_helper'

class ExtrasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get import_devices" do
    get :import_devices
    assert_response :success
  end

  test "should get import_metrics" do
    get :import_metrics
    assert_response :success
  end

  test "should get export_devices" do
    get :export_devices
    assert_response :success
  end

  test "should get export_metrics" do
    get :export_metrics
    assert_response :success
  end

end
