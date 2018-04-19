class Bucket < ApplicationRecord
  ONE_WEEK = 7
  belongs_to :cohort

  def self.backfill
    ActiveRecord::Base.connection.execute("TRUNCATE buckets RESTART IDENTITY")
    last_date = Order.maximum(:created_at).to_date
    data = Order.joins(:user).order(:user_id, :order_num).group_by(&:user_id)

    Cohort.find_each do |cohort|
      next if cohort.users.zero?
      cohort_start_date = cohort.start.to_date
      cohort_end_date = cohort.end.to_date
      start_date = cohort_start_date
      end_date = cohort_end_date

      lower_bound = 0
      upper_bound = lower_bound+7

      # users that signed up in this cohort
      users = User.where("users.created_at BETWEEN :start AND :end", start: start_date, end: end_date)

      while start_date < last_date
        orderers = 0
        first_time_orderers = 0

        users.each do |user|
          # orders = Order.where(user: user).order(order_num: :asc)
          orders = data[user.id]
          next if orders.blank?
          orders.each do |order|
            next if !order.created_at.between?(start_date, end_date)
            if order.order_num == 1
              first_time_orderers += 1
            else
              orderers += 1
            end
            break
          end
        end

        Bucket.create!(cohort: cohort,
                       lower_b: lower_bound,
                       upper_b: upper_bound,
                       orderers: orderers,
                       first_time_orderers: first_time_orderers)

        start_date = end_date
        end_date = start_date+ONE_WEEK
        lower_bound = (start_date - cohort_start_date).to_i
        upper_bound = (end_date - cohort_start_date).to_i
      end
    end
  end
end
