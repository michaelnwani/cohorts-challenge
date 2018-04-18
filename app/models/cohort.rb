class Cohort < ApplicationRecord
  ONE_WEEK = 7

  def self.backfill
    Cohort.destroy_all
    today = Date.today

    start_date = User.minimum(:created_at).to_date # 2012-05-16
    end_date = start_date+ONE_WEEK # 2012-05-24

    while (end_date < today)
      users = User.where(created_at: start_date..end_date) # number of signups
      Cohort.create!(start: start_date,
                     end: end_date,
                     users: users.count)
      start_date = end_date
      end_date = start_date+ONE_WEEK
    end

  end

end
