require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "find one" do
    assert_not_nil users(:user_1)
  end

  test "user should be valid" do
    user = User.new
    assert user.valid?
  end

  test "find by id that does not exist" do
    assert_raise(StandardError) { users(:user_11000) }
  end
end
