class MentorsController < ApplicationController

  def show
    @user = User.find(params[:user_id])
    records = policy_scope(:mentor_dashboard).where(mentor_id: @user).includes(:user).map(&:user)
    @mentees = records.select(&:current_cohort)

    unless MentorDashboardPolicy.new(current_user, @user).show?
      raise Pundit::NotAuthorizedError
    end
  end

end
