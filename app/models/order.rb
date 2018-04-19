class Order < ApplicationRecord
  require 'csv'

  belongs_to :user

  def self.backfill
    ActiveRecord::Base.connection.execute("TRUNCATE orders RESTART IDENTITY CASCADE")
    utc_tz = ActiveSupport::TimeZone.new('UTC')
    CSV.foreach('public/orders.csv', headers: true) do |row|
      row_hash = row.to_hash
      id = row_hash['id']
      user_id = row_hash['user_id']
      order_num = row_hash['order_num']
      created_at_tz = utc_tz.strptime(row_hash['created_at'], "%m/%d/%Y %H:%M:%S")
      updated_at_tz = utc_tz.strptime(row_hash['updated_at'], "%m/%d/%Y %H:%M:%S")
      created_at = created_at_tz.strftime("%Y-%m-%d %H:%M:%S")
      updated_at = updated_at_tz.strftime("%Y-%m-%d %H:%M:%S")

      if User.exists?(user_id)
        user = User.find(user_id)
        # want to keep track of the earliest entry since this may represent the user's signup date
        if user.created_at > created_at_tz
          user.update_attributes(created_at: created_at_tz, updated_at: updated_at_tz)
        end
      else
        User.create!(id: user_id, created_at: created_at, updated_at: updated_at)
      end

      Order.create!(id: id,
                    user_id: user_id,
                    order_num: order_num,
                    created_at: created_at,
                    updated_at: updated_at)
    end

    order_num_zero_group = Order.where(order_num: 0).group("orders.user_id, orders.id").group_by(&:user_id)
    order_num_zero_group.each_value do |orders_per_user|
      orders_per_user.sort_by { |user_order| user_order.created_at }
      order_num = 1
      orders_per_user.each do |user_order|
        user_order.update_attribute(:order_num, order_num)
        order_num += 1
      end
    end

  end
end
