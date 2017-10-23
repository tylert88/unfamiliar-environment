class Users::PerformancesController < ApplicationController

  include Users::PerformanceMixin

  after_action :verify_authorized

  before_action do
    @user = User.find(params[:user_id])
  end

  def index
    if @user.current_cohort.nil? || @user.current_cohort.curriculum_id.nil?
      redirect_to get_home_path, alert: 'Sorry!  You are not setup to see that page'
      return
    end
    authorize(Performance)

    respond_to do |format|
      format.json do
        curriculum = Curriculum.find(@user.current_cohort.curriculum_id)
        @standards = curriculum.standards.includes(:objectives, :subject).order('subjects.position ASC').ordered
        render json: {
          standards: standards_json(@standards, @user),
          updateable: policy(Performance).update?,
        }, serializer: nil
      end
      format.html
    end
  end

  def create
    @cohort = Cohort.find_by(id: params[:cohort_id])
    @performance = Performance.find_or_initialize_by(
      user: @user,
      objective_id: params[:performance][:objective_id],
    )
    authorize(@performance)
    respond_to do |format|
      if @performance.update_score(current_user, params[:performance][:score])
        format.html do
          redirect_to(
            cohort_performances_path(@cohort),
            notice: 'Performance was saved successfully'
          )
        end
        format.json do
          render json: {
            score: @performance.score,
          }, serializer: nil
        end
      else
        format.html do
          redirect_to(
            cohort_performances_path(@cohort),
            alert: 'Performance could not be saved'
          )
        end
        format.json do
          head :unprocessable_entity
        end
      end
    end
  end

  def update_all
    objectives = Objective.where(id: params[:objective_ids])
    performances = objectives.map do |objective|
      performance = Performance.find_or_initialize_by(
        user_id: @user.id,
        objective_id: objective.id
      )
      authorize(performance)
      performance.update_score(current_user, params[:score])
      objective_json(objective, performance)
    end
    render json: performances, serializer: nil
  end

end
