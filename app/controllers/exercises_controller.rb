class ExercisesController < ApplicationController

  after_action :verify_authorized
  before_filter :fetch_curriculum

  def index
    authorize(Exercise)
    @exercises = Exercise.order(:name).where(curriculum_id: @curriculum.id)
  end

  def new
    @exercise = Exercise.new
    @standards_json = standards_json(@exercise)
    authorize(@exercise)
  end

  def create
    @exercise = Exercise.new(exercise_params)
    authorize(@exercise)

    if @exercise.save
      redirect_to curriculum_exercises_path(@curriculum), :notice => 'Exercise successfully created'
    else
      render :new
    end
  end

  def show
    @exercise = Exercise.find(params[:id])
    authorize(@exercise)
  end

  def edit
    @exercise = Exercise.find(params[:id])
    @standards_json = standards_json(@exercise)
    authorize(@exercise)
  end

  def update
    @exercise = Exercise.find(params[:id])
    authorize(@exercise)

    if @exercise.update_attributes(exercise_params)
      @exercise.objective_ids = params[:exercise][:objective_ids]
      redirect_to curriculum_exercises_path, :notice => 'Exercise successfully created'
    else
      @standards_json = standards_json(@exercise)
      render :edit
    end
  end

  private

  def fetch_curriculum
    @curriculum = Curriculum.find(params[:curriculum_id])
  end

  def exercise_params
    params
      .require(:exercise)
      .permit(:name, :github_repo, :tag_list, :response_type, :objective_ids)
      .merge(curriculum_id: @curriculum.id)
  end

  def standards_json(exercise)
    standards = @curriculum.standards.ordered.includes(:objectives)
    selected_ids = if params[:exercise] && params[:exercise][:objective_ids]
      params[:exercise][:objective_ids].map(&:to_i)
    else
      exercise.objective_ids
    end

    standards.map do |standard|
      {
        id: standard.id,
        name: standard.name,
        tags: standard.tags,
        standard_path: standard_path(standard),
        objectives: standard.objectives.map do |objective|
          {
            id: objective.id,
            name: objective.name,
            selected: selected_ids.include?(objective.id),
            objective_path: objective_path(objective)
          }
        end
      }
    end
  end

end
