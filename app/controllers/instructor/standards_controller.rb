class Instructor::StandardsController < ApplicationController
  after_action :verify_authorized

  before_action do
    @curriculum = Curriculum.find_by(id: params[:curriculum_id])
  end

  def reorder
    @standards = @curriculum.standards.where(subject_id: params[:subject_id]).ordered
    authorize(@standards)
  end

  include Reorderable
  def update_order
    authorize(Standard)
    update_positions Standard.ordered.where(curriculum_id: @curriculum.id, subject_id: params[:subject_id])
  end

  def new
    @standard = @curriculum.standards.new(subject_id: params[:subject_id])
    authorize(@standard)
  end

  def create
    @standard = @curriculum.standards.new(standard_params.merge(user_id: current_user.id))
    authorize(@standard)
    if @standard.save
      redirect_to standard_path(@standard), notice: "Standard Successfully Saved"
    else
      render action: :new
    end
  end

  def show
    @standard = Standard.find(params[:id])
    authorize(@standard)
    @curriculum = @standard.curriculum
    @learning_experiences = LearningExperience.for_standard(@standard)
  end

  def edit
    @standard = Standard.find(params[:id])
    @curriculum = @standard.curriculum
    authorize(@standard)
  end

  def update
    @standard = Standard.find(params[:id])
    @curriculum = @standard.curriculum
    authorize(@standard)
    new_params = standard_params.merge(
      user_id: current_user.id,
      curriculum_id: params[:standard][:curriculum_id]
    )
    if @standard.update(new_params)
      if params[:commit] == 'Save and Next'
        next_standard = next_standard(@curriculum, @standard)
        path = next_standard ? edit_standard_path(next_standard) : curriculum_path(@curriculum)
      else
        path = case params[:return_to]
        when 'index'
          curriculum_path(@curriculum)
        when 'progress'
          progress_curriculum_path(@curriculum)
        when 'performances'
          cohort_performances_path(params[:cohort_id])
        else
          standard_path(@standard)
        end
      end
      redirect_to path, notice: "Standard Successfully Saved"
    else
      render :edit
    end
  end

  def delete
    @standard = Standard.find(params[:id])
    @curriculum = @standard.curriculum
    @objectives = @standard.objectives
    @performances = @standard.performances
    authorize(@standard)
  end

  def destroy
    @standard = Standard.find(params[:id])
    @curriculum = @standard.curriculum
    authorize(@standard)
    @standard.destroy
    redirect_to curriculum_path(@curriculum), notice: "Standard was deleted"
  end

  def merge_objectives
    @standard = Standard.find(params[:id])
    authorize(@standard)
    merger = ObjectiveMerger.merge(
      params[:objectives].keys,
      params[:new_objective_name],
      current_user
    )
    if merger.success
      redirect_to standard_path(@standard), notice: merger.message
    else
      redirect_to standard_path(@standard), alert: merger.message
    end
  end

  private

  def next_standard(curriculum, standard)
    standards = curriculum.standards.ordered
    index = standards.index(standard)
    standards[index + 1]
  end

  def standard_params
    attributes = params.require(:standard).permit(
      :name,
      :description,
      :resources,
      :guiding_questions,
      :instructor_notes,
      :subject_id,
    )
    attributes[:tags] = params[:standard][:tags].split(",").map(&:strip)
    attributes
  end
end
