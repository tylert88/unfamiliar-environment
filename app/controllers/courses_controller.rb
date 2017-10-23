class CoursesController < ApplicationController

  after_action :verify_authorized

  def index
    @courses = Course.order('lower(name)')
    authorize(Course)
  end

  def new
    @course = Course.new
    authorize(@course)
  end

  def create
    @course = Course.new(course_params)
    authorize(@course)

    if @course.save
      redirect_to(
        course_path(@course),
        notice: 'Course was added successfully'
      )
    else
      render :new
    end
  end

  def clone
    source = Course.find(params[:id])
    authorize(source)

    course = Course.new(name: "Copy of #{source.name}")

    source.expectations.each do |requirement|
      course.expectations.build(
        requirement.attributes.except('id', 'course_id', 'created_at', 'updated_at')
      )
    end

    course.save!

    redirect_to(
      course_path(course),
      notice: 'Course was cloned successfully'
    )
  end

  def edit
    @course = Course.find(params[:id])
    authorize(@course)
  end

  def show
    @course = Course.find(params[:id])
    authorize(@course)
  end

  def update
    @course = Course.find(params[:id])
    authorize(@course)

    if @course.update(course_params)
      redirect_to(
        course_path(@course),
        notice: 'Course was updated successfully'
      )
    else
      render :edit
    end
  end

  def destroy
    @course = Course.find(params[:id])
    authorize(@course)
    if @course.destroy
      flash[:notice] = 'Course removed successfully'
    else
      flash[:alert] = 'Course could not be destroyed'
    end
    redirect_to(courses_path)
  end

  private

  def course_params
    params.require(:course).permit( :name )
  end
end
