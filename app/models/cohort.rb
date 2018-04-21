class Cohort < ApplicationRecord
  ONE_WEEK = 7

  has_many :buckets

  def self.backfill
    ActiveRecord::Base.connection.execute("TRUNCATE cohorts RESTART IDENTITY CASCADE")
    last_date = User.maximum(:created_at).to_date

    start_date = User.minimum(:created_at).to_date # 2012-05-16
    end_date = start_date+ONE_WEEK # 2012-05-24

    while (start_date < last_date)
      users = User.where(created_at: start_date..end_date) # number of signups
      Cohort.create!(start: start_date,
                     end: end_date,
                     users: users.count)
      start_date = end_date
      end_date = start_date+ONE_WEEK
    end
  end

  def self.challenge(default=8)
    Cohort.joins(:buckets) \
          .select("cohorts.id AS cohort_id, cohorts.start, cohorts.end, cohorts.users, buckets.*") \
          .where("cohorts.start >= :start_date", start_date: Cohort.maximum(:start) - default.weeks) \
          .order("cohorts.start DESC, buckets.lower_b ASC") \
          .group_by(&:cohort_id)
  end

end
