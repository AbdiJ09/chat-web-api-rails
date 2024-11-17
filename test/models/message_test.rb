require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "should not save message without content" do
    message = Message.new(user_id: 1, chatroom_id: 1)
    assert_not message.save, "Saved the message without content"
  end

  test "should save message with content" do
    user = User.create!(name: "John Doe")
    chatroom = Chatroom.create!(name: "Chatroom 1")

    message = Message.new(user: user, chatroom: chatroom, content: "Hello!")
    assert message.save, "Could not save the message with content"
  end

  test "should belong to a user" do
    message = Message.new(content: "Hello!", chatroom_id: 1)
    assert_not message.valid?, "Message should be invalid without user_id"
    assert_equal [ "must exist" ], message.errors[:user], "Expected error on user association"
  end

  test "should belong to a chatroom" do
    message = Message.new(content: "Hello!", user_id: 1)
    assert_not message.valid?, "Message should be invalid without chatroom_id"
    assert_equal [ "must exist" ], message.errors[:chatroom], "Expected error on chatroom association"
  end
end
