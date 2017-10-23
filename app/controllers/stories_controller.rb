class StoriesController < InstructorRequiredController

  before_action do
    @class_project = ClassProject.find(params[:class_project_id])
    @epic = Epic.find(params[:epic_id])
  end

  include Reorderable
  def reorder
    update_positions Story.ordered.where(epic_id: @epic)
  end

  def create
    @story = Story.new(story_params)
    @story.epic = @epic

    if @story.save
      redirect_to(
        class_project_epic_path(@class_project, @epic),
        notice: 'Story was added successfully'
      )
    else
      render :new
    end
  end

  def edit
    @story = @epic.stories.find(params[:id])
  end

  def update
    @story = @epic.stories.find(params[:id])

    if @story.update(story_params)
      redirect_to(
        class_project_epic_path(@class_project, @epic),
        notice: 'Story was updated successfully'
      )
    else
      render :edit
    end
  end

  def destroy
    @story = @epic.stories.find_by(id: params[:id])
    @story.try(:destroy)
    redirect_to(
      class_project_epic_path(@class_project, @epic),
      notice: 'Story removed successfully'
    )
  end

  private

  def story_params
    params.require(:story).permit(
      :epic_id,
      :title,
      :description,
      :story_type,
      :slug,
    )
  end
end
