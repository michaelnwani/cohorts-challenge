require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "find one" do
    assert_not_nil orders(:one)
  end

  test "order should not be valid without user" do
    order = Order.new
    assert_not order.valid?
  end

  test "find by id that does not exist" do
    assert_raise(StandardError) { orders(:ten) }
  end
end
