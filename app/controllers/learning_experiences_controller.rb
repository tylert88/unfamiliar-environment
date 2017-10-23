class LearningExperiencesController < ApplicationController

  after_action :verify_authorized

  before_action do
    @curriculum = Curriculum.find(params[:curriculum_id])
  end

  def index
    @learning_experiences = @curriculum.learning_experiences.ordered.includes(:objectives)
    @mainline_experiences, @other_experiences = @learning_experiences.partition(&:mainline?)
    @objectives = @curriculum.objectives
    if @objectives.present?
      @uncovered = @objectives - @mainline_experiences.flat_map(&:objectives).uniq
      @covered = @objectives.length - @uncovered.length
      @percent_covered = ((@covered.to_f / @objectives.length) * 100).to_i
    else
      @percent_covered = 0
      @covered = 0
    end
    authorize(@learning_experiences)
  end

  def reorder
    @learning_experiences = @curriculum.learning_experiences.mainline.ordered.includes(:subject)
    authorize(@learning_experiences)
  end

  include Reorderable
  def update_order
    authorize(LearningExperience)
    update_positions LearningExperience.mainline.ordered.where(curriculum_id: @curriculum.id)
  end

  def assign
    authorize(LearningExperience)

    respond_to do |format|
      format.html do
      end
      format.json do
        learning_experiences = @curriculum.learning_experiences.ordered
        cohorts = Cohort.all.sort_by(&:name)
        assigned_experiences = AssignedLearningExperience.where(learning_experience_id: learning_experiences)
        assigned_experiences = assigned_experiences.inject({}) do |result, assignment|
          result[assignment.learning_experience_id] ||= []
          result[assignment.learning_experience_id] << assignment.cohort_id
          result
        end

        json = {
          currentCohortId: current_user.staffings.active.first.try(:cohort).try(:id),
          cohorts: cohorts.map{|cohort| {id: cohort.id, name: cohort.name} },
          learning_experiences: learning_experiences.map{|experience|
            {
              id: experience.id,
              name: experience.name,
              assignedCohortIds: assigned_experiences.fetch(experience.id) {[]},
              assignmentUrl: assign_curriculum_learning_experience_path(@curriculum, experience)
            }
          }
        }

        render json: json, serializer: nil
      end
    end
  end

  def create_assignment
    @learning_experience = @curriculum.learning_experiences.find(params[:id])
    authorize(@learning_experience)

    if params[:assign]
      AssignedLearningExperience.create!(
        learning_experience: @learning_experience,
        cohort: Cohort.find(params[:assign])
      )
    elsif params[:unassign]
      AssignedLearningExperience.where(
        learning_experience_id: @learning_experience,
        cohort_id: params[:unassign]
      ).destroy_all
    end

    render nothing: true
  end

  def new
    @learning_experience = LearningExperience.new
    authorize(@learning_experience)
    @standards_json = standards_json(@learning_experience)
  end

  def create
    @learning_experience = @curriculum.learning_experiences.new(learning_experience_params.merge(user_id: current_user.id))
    authorize(@learning_experience)
    if @learning_experience.save
      @learning_experience.objective_ids = params[:learning_experience][:objective_ids]
      redirect_to curriculum_learning_experience_path(@curriculum, @learning_experience), notice: "Go learn you some stuff!"
    else
      @standards_json = standards_json(@learning_experience)
      render action: :new
    end
  end

  def show
    @learning_experience = @curriculum.learning_experiences.find(params[:id])
    authorize(@learning_experience)

    unless current_user.instructor?
      redirect_to "/redirects/learning_experiences/#{@learning_experience.to_param}"
    end
  end

  def edit
    @learning_experience = @curriculum.learning_experiences.find(params[:id])
    authorize(@learning_experience)
    @standards_json = standards_json(@learning_experience)
  end

  def update
    @learning_experience = @curriculum.learning_experiences.find(params[:id])
    authorize(@learning_experience)
    if @learning_experience.update(learning_experience_params.merge(user_id: current_user.id))
      @learning_experience.objective_ids = params[:learning_experience][:objective_ids]
      redirect_to curriculum_learning_experience_path(@curriculum, @learning_experience), notice: "Go learn you some stuff!"
    else
      @standards_json = standards_json(@learning_experience)
      render action: :edit
    end
  end

  def destroy
    @learning_experience = @curriculum.learning_experiences.find(params[:id])
    authorize(@learning_experience)
    @learning_experience.destroy
    redirect_to curriculum_learning_experiences_path(@curriculum), notice: "So sad :("
  end

  private

  def learning_experience_params
    params.require(:learning_experience).permit(
      :name,
      :description,
      :subject_id,
      :section,
      :mainline,
      :instructor_notes,
      :suggested_days
    )
  end

  def standards_json(learning_experience)
    standards = @curriculum.standards.ordered.includes(:objectives)
    selected_ids = if params[:learning_experience] && params[:learning_experience][:objective_ids]
      params[:learning_experience][:objective_ids].map(&:to_i)
    else
      learning_experience.objective_ids
    end

    if learning_experience.subject
      standards = standards.sort_by{|standard|
        [standard.subject == learning_experience.subject ? -1 : standard.position] 
      }
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
