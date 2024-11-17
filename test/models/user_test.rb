require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without name" do
    user = User.new
    assert_not user.save, "Saved the user without a name"
  end

  test "should save user with a name" do
    user = User.new(name: "Alice")
    assert user.save, "Couldn't save the user with a name"
  end
  test "should have many chatrooms" do
    user = users(:one)
    assert_respond_to user, :chatrooms, "User does not have chatrooms association"
    assert_equal user.chatrooms.count, 0, "User should not have any chatrooms initially"
  end
  test "should associate with chatrooms correctly" do
    user = users(:one)
    chatroom = chatrooms(:one)

    user.chatrooms << chatroom
    user.save

    assert_includes user.chatrooms, chatroom, "User is not correctly associated with chatroom"
    assert_equal user.chatrooms.count, 1, "User should have 1 chatroom"
  end
end
