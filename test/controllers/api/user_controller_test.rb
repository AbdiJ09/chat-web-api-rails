require "test_helper"

class Api::UserControllerTest < ActionDispatch::IntegrationTest
  test "should create user with valid params" do
    valid_params = { user: { name: "Abdi" } }
    assert_difference "User.count", 1 do
      post api_users_url, params: valid_params, as: :json
    end
    User.last
    assert_response :created
    assert_equal "Abdi", JSON.parse(response.body)["name"]
  end
  test "should not create user with invalid params" do
    invalid_params = { user: { name: "" } }

    assert_no_difference "User.count" do
      post api_users_url, params: invalid_params, as: :json
    end

    assert_response :unprocessable_entity
    assert_includes JSON.parse(response.body).keys, "name"
  end
end
