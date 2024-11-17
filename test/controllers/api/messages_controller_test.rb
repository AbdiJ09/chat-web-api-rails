require "test_helper"

class Api::MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chatroom = Chatroom.create!(name: "Test Chatroom")
    @user = User.create!(name: "Test User")
  end

  test "should create message with valid params" do
    valid_params = {
      message: { content: "Hello, world!" },
      chatroom_id: @chatroom.id,
      user_id: @user.id
    }

    assert_difference "@chatroom.messages.count", 1 do
      post api_chatroom_messages_url(@chatroom), params: valid_params, as: :json
    end

    assert_response :created
    response_body = JSON.parse(response.body)

    assert_equal "Hello, world!", response_body["content"]
    assert_equal @user.id, response_body["user_id"]
    assert_equal @chatroom.id, response_body["chatroom_id"]
  end

  test "should not create message with invalid params" do
    invalid_params = {
      message: { content: "" },
      chatroom_id: @chatroom.id,
      user_id: @user.id
    }

    assert_no_difference "@chatroom.messages.count" do
      post api_chatroom_messages_url(@chatroom), params: invalid_params, as: :json
    end

    assert_response :unprocessable_entity
    response_body = JSON.parse(response.body)

    assert_includes response_body.keys, "content"
  end

  test "should return not found for invalid user" do
    invalid_user_params = {
      message: { content: "Invalid user message" },
      chatroom_id: @chatroom.id,
      user_id: 9999
    }

    assert_no_difference "@chatroom.messages.count" do
      post api_chatroom_messages_url(@chatroom), params: invalid_user_params, as: :json
    end

    assert_response :not_found
    response_body = JSON.parse(response.body)

    assert_equal "User not found", response_body["message"]
  end

  test "should list all messages in a chatroom" do
    @chatroom.messages.create!(content: "First message", user: @user)
    @chatroom.messages.create!(content: "Second message", user: @user)

    get api_chatroom_messages_url(@chatroom), as: :json

    assert_response :success
    response_body = JSON.parse(response.body)

    assert_equal 2, response_body.size
    assert_equal "First message", response_body[0]["content"]
    assert_equal "Second message", response_body[1]["content"]
  end
end
