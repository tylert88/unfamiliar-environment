class Instructor::SubjectsController < ApplicationController
  after_action :verify_authorized

  before_action do
    @curriculum = Curriculum.find_by(id: params[:curriculum_id])
  end

  def new
    @subject = @curriculum.subjects.new
    authorize(@subject)
  end

  def index
    @subjects = @curriculum.subjects
    authorize(@subjects)
  end

  def reorder
    @subjects = @curriculum.subjects.ordered
    authorize(@subjects)
  end

  include Reorderable
  def update_order
    authorize(Subject)
    update_positions Subject.ordered.where(curriculum_id: @curriculum.id)
  end

  def create
    @subject = @curriculum.subjects.new(subject_params)
    authorize(@subject)
    if @subject.save
      redirect_to curriculum_subjects_path(@curriculum), notice: "Subject Successfully Saved"
    else
      render action: :new
    end
  end

  def show
    @subject = Subject.find(params[:id])
    authorize(@subject)
    @curriculum = @subject.curriculum
  end

  def edit
    @subject = Subject.find(params[:id])
    @curriculum = @subject.curriculum
    @learning_experiences_json = learning_experiences_json(@subject.learning_experiences)
    authorize(@subject)
  end

  def update
    @subject = Subject.find(params[:id])
    @curriculum = @subject.curriculum
    authorize(@subject)
    if @subject.update(subject_params)
      @subject.learning_experience_ids = params[:subject][:learning_experience_ids]
      redirect_to [@curriculum, @subject], notice: "Subject Successfully Saved"
    else
      render :edit
    end
  end

  def delete
    @subject = Subject.find(params[:id])
    @curriculum = @subject.curriculum
    authorize(@subject)
  end

  def destroy
    @subject = Standard.find(params[:id])
    @curriculum = @subject.curriculum
    authorize(@subject)
    @subject.destroy
    redirect_to curriculum_path(@curriculum), notice: "Subject was deleted"
  end

  private

  def subject_params
   params.require(:subject).permit(:name)
  end

  def learning_experiences_json(active_learning_experiences)
    learning_experiences = @curriculum.learning_experiences
    selected_ids = active_learning_experiences.map(&:id)
    learning_experiences.map do |le|
      {
        id: le.id,
        name: le.name,
        learning_experience_path: curriculum_learning_experience_path(@curriculum, le),
        selected: selected_ids.include?(le.id)
      }
    end
  end

end
