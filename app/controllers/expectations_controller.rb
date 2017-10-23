class ExpectationsController < ApplicationController

  before_action do
    @course = Course.find(params[:course_id])
  end

  def new
    @expectation = @course.expectations.new
    authorize(@expectation)
  end

  def create
    @expectation = @course.expectations.new(expectation_params)
    authorize(@expectation)

    if @expectation.save
      redirect_to(
        course_path(@course),
        notice: 'Expectation was added successfully'
      )
    else
      render :new
    end
  end

  def edit
    @expectation = @course.expectations.find(params[:id])
    authorize(@expectation)
  end

  def update
    @expectation = @course.expectations.find(params[:id])
    authorize(@expectation)

    if @expectation.update(expectation_params)
      redirect_to(
        course_path(@course),
        notice: 'Expectation was updated successfully'
      )
    else
      render :edit
    end
  end

  def destroy
    @expectation = @course.expectations.find(params[:id])
    authorize(@expectation)
    if @expectation.destroy
      flash[:notice] = 'Expectation removed successfully'
    else
      flash[:alert] = 'Expectation could not be destroyed'
    end
    redirect_to(course_path(@course))
  end

  private

  def expectation_params
    params.require(:expectation).permit(
      :name,
      :description
    )
  end
end
