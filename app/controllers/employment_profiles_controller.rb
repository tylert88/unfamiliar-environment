class EmploymentProfilesController < ApplicationController

  after_action :verify_authorized

  before_action do
    @user = User.find(params[:user_id])
    @employment_profile = EmploymentProfile.find_or_initialize_by(user_id: @user.id)
    authorize(@employment_profile)
  end

  def create
    @employment_profile.attributes = employment_profile_attributes
    if @employment_profile.save
      redirect_to(
        user_employment_profile_path(@user, cohort_id: @cohort),
        notice: "Profile was saved"
      )
    else
      render :edit
    end
  end

  def update
    if @employment_profile.update(employment_profile_attributes)
      redirect_to(
        user_employment_profile_path(@user, cohort_id: @cohort),
        notice: "Profile was saved"
      )
    else
      render :edit
    end
  end

  private def employment_profile_attributes
    params.require(:employment_profile).permit(
      :strengths,
      :preferred_locations,
      :looking_for,
      :status,
      :show_email,
      :remote_work,
      :bio,
      :headline,
    )
  end

end
