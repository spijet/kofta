require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  test 'should get gc' do
    get :gc
    assert_response :success
  end

  test 'should get rufus' do
    get :rufus
    assert_response :success
  end

  test 'should get sidekiq' do
    get :sidekiq
    assert_response :success
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

end
