module Users
  class ExpectationsController < ApplicationController
    before_action do
      @user = User.find(params[:user_id])
    end

    def index
      @users = User.for_cohort(@user.current_cohort).ordered
      @course = @user.current_cohort.course
      @expectations = Expectation.for_cohort(@user.current_cohort)

      @statuses = policy_scope(ExpectationStatus)
        .where(cohort_id: @user.current_cohort, user_id: @user)
        .order(:created_at)
        .group_by(&:expectation_id)

      raise Pundit::NotAuthorizedError unless UserExpectationPolicy.new(current_user, @user).index?
    end
  end
end
