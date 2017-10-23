class EpicsController < ApplicationController

  before_action do
    @class_project = ClassProject.find(params[:class_project_id])
  end

  def index
    @epics = @class_project.epics.ordered
  end

  include Reorderable
  def reorder
    update_positions Epic.ordered.where(class_project_id: @class_project)
  end

  def new
    @epic = Epic.new
  end

  def create
    @epic = Epic.new(epic_params)
    @epic.class_project = @class_project

    if @epic.save
      redirect_to(
        class_project_epic_path(@class_project, @epic),
        notice: 'Epic was added successfully'
      )
    else
      render :new
    end
  end

  def show
    @epic = @class_project.epics.find(params[:id])
    @story = Story.new
  end

  def edit
    @epic = @class_project.epics.find(params[:id])
  end

  def update
    @epic = @class_project.epics.find(params[:id])

    if @epic.update(epic_params)
      redirect_to(
        class_project_epic_path(@class_project, @epic),
        notice: 'Epic was updated successfully'
      )
    else
      render :edit
    end
  end

  def destroy
    @epic = @class_project.epics.find_by(id: params[:id])
    @epic.try(:destroy)
    redirect_to(
      class_project_epics_path(@class_project),
      notice: 'Epic removed successfully'
    )
  end

  private

  def epic_params
    params.require(:epic).permit(
      :class_project_id,
      :name,
      :category,
      :wireframes,
      :position,
      :label,
    )
  end
end
