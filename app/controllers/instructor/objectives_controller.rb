class Instructor::ObjectivesController < ApplicationController
  after_action :verify_authorized

  before_action do
    @standard = Standard.find_by(id: params[:standard_id])
    @curriculum = @standard.try(:curriculum)
  end

  def reorder
    @objectives = @standard.objectives.ordered
    authorize(@objectives)
  end

  include Reorderable
  def update_order
    authorize(Objective)
    update_positions Objective.ordered.where(standard_id: @standard.id)
  end

  def new
    @objective = Objective.new
    @objective.questions.build
    authorize(@objective)
  end

  def create
    @standard = Standard.find(params[:standard_id])
    @objective = Objective.new(objective_params.merge(standard_id: params[:standard_id], user_id: current_user.id))
    authorize(@objective)
    if @objective.save
      redirect_to standard_path(@objective.standard), notice: "Objective Successfully Saved"
    else
      render :new
    end
  end

  def show
    @objective = Objective.find(params[:id])
    authorize(@objective)
    @curriculum = @objective.standard.curriculum
    @learning_experiences = @objective.learning_experiences.ordered
  end

  def edit
    @objective = Objective.find(params[:id])
    @objective.questions.build if @objective.questions.length == 0
    @standard = @objective.standard
    @curriculum = @standard.curriculum
    authorize(@objective)
  end

  def update
    @objective = Objective.find(params[:id])
    @standard = @objective.standard
    @curriculum = @standard.curriculum
    authorize(@objective)
    if @objective.update(objective_params.merge(user_id: current_user.id))
      if params[:commit] == 'Save and Next'
        objectives = @standard.objectives.ordered
        index = objectives.index(@objective)
        if index < objectives.length - 1
          next_objective = objectives[index + 1]
          path = edit_objective_path(next_objective)
        else
          path = standard_path(@standard)
        end
      else
        path = case params[:return_to]
        when 'index'
          curriculum_path(@curriculum)
        when 'progress'
          progress_curriculum_path(@curriculum)
        when 'performances'
          cohort_performances_path(params[:cohort_id])
        when 'standard'
          standard_path(@standard)
        else
          objective_path(@objective)
        end
      end
      redirect_to path, notice: "Objective Successfully Saved"
    else
      render :edit
    end
  end

  def delete
    @objective = Objective.find(params[:id])
    @standard = @objective.standard
    @curriculum = @standard.curriculum
    @performances = @objective.performances
    authorize(@objective)
  end

  def destroy
    @objective = Objective.find(params[:id])
    @standard = @objective.standard
    authorize(@objective)
    @objective.destroy
    redirect_to standard_path(@standard), notice: "Objective was deleted"
  end

  private

  def objective_params
    params.require(:objective).permit(
      :standard_id,
      :name,
      :description,
      :guiding_questions,
      :assessing_questions,
      :resources,
      :instructor_notes,
      questions_attributes: [:id, :question, :question_type, :correct_answer]
    )
  end
end
