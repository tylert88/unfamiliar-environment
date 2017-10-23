class Users::LearningExperiencesController < ApplicationController

  include Users::PerformanceMixin

  after_action :verify_authorized

  before_action do
    @user = User.find(params[:user_id])
  end

  def index
    @curriculum = Curriculum.find_by(id: @user.current_cohort.curriculum_id)
    @learning_experiences = @curriculum.learning_experiences.mainline.ordered
    authorize(LearningExperience)
  end

  def show
    if current_user.instructor?
      @learning_experience = LearningExperience.find_by_id(params[:id])
    else
      raise Pundit::NotAuthorizedError, "you are not that user" unless current_user == @user
      @curriculum = Curriculum.find_by(id: @user.current_cohort.curriculum_id)
      @learning_experience = @curriculum.learning_experiences.find(params[:id])
    end

    @user_zpd = ZpdResponse.find_by(resource: @learning_experience)

    authorize(LearningExperience)

    respond_to do |format|
      format.html
      format.json do
        standards = @learning_experience.objectives.includes(:standard).group_by(&:standard).sort_by{|standard, _| standard.position }
        render json: {
          standards: grouped_standards_json(standards, @user),
          updateable: policy(Performance).update?,
        }, serializer: nil
      end
    end
  end
end
