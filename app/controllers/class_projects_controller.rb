class ClassProjectsController < InstructorRequiredController

  def index
    @class_projects = ClassProject.ordered
  end

  def new
    @class_project = ClassProject.new
  end

  def create
    @class_project = ClassProject.new(class_project_params)

    if @class_project.save
      redirect_to(
        class_projects_path,
        notice: 'Class Project successfully created'
      )
    else
      render :new
    end
  end

  def show
    @class_project = ClassProject.find(params[:id])
    redirect_to class_project_epics_path(@class_project)
  end

  def edit
    @class_project = ClassProject.find(params[:id])
  end

  def update
    @class_project = ClassProject.find(params[:id])

    if @class_project.update(class_project_params)
      redirect_to(
        class_projects_path,
        notice: 'Class Project successfully updated'
      )
    else
      render :edit
    end
  end

  private

  def class_project_params
    params.require(:class_project).permit(:name, :slug)
  end
end
