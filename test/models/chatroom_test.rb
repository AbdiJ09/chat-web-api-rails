require "test_helper"

class ChatroomTest < ActiveSupport::TestCase
  test "should not save chatroom without name" do
    chatroom = Chatroom.new
    assert_not chatroom.save, "Saved the chatroom without a name"
    assert_includes chatroom.errors[:name], "can't be blank"
  end

  test "should save chatroom with valid name" do
    chatroom = Chatroom.new(name: "General")
    assert chatroom.save, "Failed to save the chatroom with a valid name"
  end

  test "should have many messages" do
    chatroom = chatrooms(:one)
    assert_respond_to chatroom, :messages, "Chatroom does not have a messages association"
    assert_equal chatroom.messages.count, 2, "Chatroom does not correctly associate messages"
  end
  test "should destroy messages when chatroom is destroyed" do
    chatroom = chatrooms(:one)
    assert_difference("Message.count", -chatroom.messages.count) do
      chatroom.destroy
    end
  end
end
