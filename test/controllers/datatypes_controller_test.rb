require 'test_helper'

class DatatypesControllerTest < ActionController::TestCase
  setup do
    @datatype = datatypes(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:datatypes)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create datatype' do
    assert_difference('Datatype.count') do
      post :create, datatype: { excludes: @datatype.excludes, index_oid: @datatype.index_oid, name: @datatype.name, oid: @datatype.oid, table: @datatype.table }
    end

    assert_redirected_to datatype_path(assigns(:datatype))
  end

  test 'should show datatype' do
    get :show, id: @datatype
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @datatype
    assert_response :success
  end

  test 'should update datatype' do
    patch :update, id: @datatype, datatype: { excludes: @datatype.excludes, index_oid: @datatype.index_oid, name: @datatype.name, oid: @datatype.oid, table: @datatype.table }
    assert_redirected_to datatype_path(assigns(:datatype))
  end

  test 'should destroy datatype' do
    assert_difference('Datatype.count', -1) do
      delete :destroy, id: @datatype
    end

    assert_redirected_to datatypes_path
  end
end
