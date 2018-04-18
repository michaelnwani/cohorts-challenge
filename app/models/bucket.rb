class Bucket < ApplicationRecord
  ONE_WEEK = 7
  belongs_to :cohort

  def self.backfill
    ActiveRecord::Base.connection.execute("TRUNCATE buckets RESTART IDENTITY")
    today = Date.today

    Cohort.find_each do |cohort|
      next if cohort.users.zero?
      start_date = cohort.start.to_date
      end_date = cohort.end.to_date

      while (end_date < today)
        users = User.joins(:orders) \
                  .select("DISTINCT user_id, users.created_at AS signup_date, MIN(orders.created_at) AS first_order_date") \
                  .where("users.created_at BETWEEN :start AND :end", start: start_date, end: end_date) \
                  .group("orders.user_id, signup_date") \
                  .pluck("user_id, users.created_at AS signup_date, MIN(orders.created_at) AS first_order_date")

        orderers = 0
        first_time_orderers = 0

        users.each do |user|
          signup_date = user[1].to_date
          first_order_date = user[2].to_date
          if first_order_date.between?(signup_date, signup_date+ONE_WEEK)
            orderers += 1
          else
            first_time_orderers += 1
          end
        end

        Bucket.create!(cohort: cohort,
                       start: start_date,
                       end: end_date,
                       orderers: orderers,
                       first_time_orderers: first_time_orderers)

        start_date = end_date
        end_date = start_date+ONE_WEEK
      end
    end
  end
end
