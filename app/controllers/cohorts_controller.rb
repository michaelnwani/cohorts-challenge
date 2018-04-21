class CohortsController < ApplicationController
  def index
    @max_upper_b = Bucket.maximum(:upper_b)
    @current_lower_b = 0
    @current_upper_b = @current_lower_b+7

    @buckets_cohort = Cohort.challenge
  end

  def show
    puts "params: #{params}"
    @max_upper_b = Bucket.maximum(:upper_b)
    @current_lower_b = 0
    @current_upper_b = @current_lower_b+7

    @buckets_cohort = Cohort.challenge(params[:id].to_i)
  end
end
