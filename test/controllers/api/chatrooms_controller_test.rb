require "test_helper"

class Api::ChatroomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @chatroom = chatrooms(:one)
  end

  test "should list all chatrooms" do
    get api_chatrooms_url, as: :json
    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal Chatroom.count, response_body.size
  end

  test "should show a specific chatroom with messages and users" do
    get api_chatroom_url(@chatroom), as: :json
    assert_response :success

    response_body = JSON.parse(response.body)
    assert_equal @chatroom.name, response_body["name"]
    assert_includes response_body.keys, "messages"
  end

  test "should create a new chatroom with valid params" do
    valid_params = { chatroom: { name: "New Chatroom" } }

    assert_difference "Chatroom.count", 1 do
      post api_chatrooms_url, params: valid_params, as: :json
    end

    assert_response :created
    response_body = JSON.parse(response.body)
    assert_equal "New Chatroom", response_body["name"]
  end

  test "should not create chatroom with invalid params" do
    invalid_params = { chatroom: { name: "" } }

    assert_no_difference "Chatroom.count" do
      post api_chatrooms_url, params: invalid_params, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should join a chatroom" do
    join_params = { user_id: @user.id }

    assert_difference "@chatroom.users.count", 1 do
      post join_api_chatroom_url(@chatroom), params: join_params, as: :json
    end

    assert_response :ok
    response_body = JSON.parse(response.body)
    assert_equal @chatroom.id, response_body["id"]
  end

  test "should return join status for a user" do
    get join_status_api_chatroom_url(@chatroom, user_id: @user.id), as: :json
    assert_response :ok

    response_body = JSON.parse(response.body)
    assert_includes response_body.keys, "joined"
  end

  test "should leave a chatroom" do
    @chatroom.users << @user

    assert_difference "@chatroom.users.count", -1 do
      delete leave_api_chatroom_url(@chatroom, user_id: @user.id), as: :json
    end

    assert_response :ok
    response_body = JSON.parse(response.body)
    assert_equal "User left the chatroom", response_body["message"]
  end

  test "should return not found for join status if chatroom does not exist" do
    get join_status_api_chatroom_url(9999, user_id: @user.id), as: :json
    assert_response :not_found

    response_body = JSON.parse(response.body)
    assert_equal "Chatroom not found", response_body["message"]
  end
end
