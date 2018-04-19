class CohortsController < ApplicationController
  def index
    @max_upper_b = Bucket.maximum(:upper_b)
    @current_lower_b = 0
    @current_upper_b = @current_lower_b+7
    @buckets_cohort = Cohort.joins(:buckets) \
                          .select("cohorts.id AS cohort_id, cohorts.start, cohorts.end, cohorts.users, buckets.*") \
                          .order("cohorts.start DESC, buckets.lower_b ASC") \
                          .group_by(&:cohort_id)
  end
end
