class MentorshipsController < ApplicationController

  before_action do
    @user = User.find(params[:student_id])
  end

  def index
    @mentorships = policy_scope(Mentorship).where(user_id: @user)
    authorize(Mentorship)
  end

  def new
    @mentorship = Mentorship.new(user: @user)
    authorize(@mentorship)
  end

  def create
    @mentorship = Mentorship.new(mentorship_params)
    @mentorship.user = @user
    authorize(@mentorship)
    if mentorship_params[:mentor_id].blank? && user_params[:email].present?
      @mentorship.mentor = User.new(user_params)
    end

    if @mentorship.save
      redirect_to(
        cohort_student_mentorships_path(@cohort, @user),
        notice: 'Mentorship successfully created'
      )
    else
      render :new
    end
  end

  def show
    @mentorship = Mentorship.where(user_id: @user).find(params[:id])
    authorize(@mentorship)
  end

  def edit
    @mentorship = Mentorship.where(user_id: @user).find(params[:id])
    authorize(@mentorship)
  end

  def update
    @mentorship = Mentorship.where(user_id: @user).find(params[:id])
    authorize(@mentorship)

    if @mentorship.update(mentorship_params)
      redirect_to(
        cohort_student_mentorships_path(@cohort, @user),
        notice: 'Mentorship successfully updated'
      )
    else
      render :edit
    end
  end

  def destroy
    @mentorship = Mentorship.where(user_id: @user).find(params[:id])
    authorize(@mentorship)
    @mentorship.destroy
    redirect_to(
      cohort_student_mentorships_path(@cohort, @user),
      notice: 'Mentorship removed successfully'
    )
  end

  private

  def mentorship_params
    params.require(:mentorship).permit(
      :company_name,
      :mentor_id,
      :status
    )
  end

  def user_params
    params.permit( :user => [:first_name, :last_name, :email] )[:user]
  end
end
