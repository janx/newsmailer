require 'test_helper'

class ReadersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:readers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reader" do
    assert_difference('Reader.count') do
      post :create, :reader => { }
    end

    assert_redirected_to reader_path(assigns(:reader))
  end

  test "should show reader" do
    get :show, :id => readers(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => readers(:one).id
    assert_response :success
  end

  test "should update reader" do
    put :update, :id => readers(:one).id, :reader => { }
    assert_redirected_to reader_path(assigns(:reader))
  end

  test "should destroy reader" do
    assert_difference('Reader.count', -1) do
      delete :destroy, :id => readers(:one).id
    end

    assert_redirected_to readers_path
  end
end
