require 'test_helper'

class SnmpquerierControllerTest < ActionController::TestCase
  test 'should get getinfo' do
    get :getinfo
    assert_response :success
  end

end
