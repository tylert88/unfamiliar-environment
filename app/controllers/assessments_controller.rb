class AssessmentsController < ApplicationController

  def index
    @assessments = Assessment.all
    authorize Assessment
  end

  def show
    @assessment = Assessment.find(params[:id])
    authorize(@assessment)
  end

  def new
    @assessment = Assessment.new
    authorize(@assessment)

    if params[:duplicate_assessment_id]
      assessment_to_duplicate = Assessment.find(params[:duplicate_assessment_id])
      authorize(@assessment)
      @assessment.attributes = assessment_to_duplicate.attributes.except(:id)
      @assessment.name = @assessment.name + " Copy"
    end
  end

  def create
    @assessment = Assessment.new(assessment_params)
    authorize(@assessment)
    if @assessment.save
      redirect_to assessment_path(@assessment), notice: "Assessment was created"
    else
      render :new
    end
  end

  def edit
    @assessment = Assessment.find(params[:id])
    authorize(@assessment)
  end

  def update
    @assessment = Assessment.find(params[:id])
    authorize(@assessment)
    if @assessment.update(assessment_params)
      redirect_to assessment_path(@assessment), notice: "Assessment was updated"
    else
      render :edit
    end
  end

  def destroy
    @assessment = Assessment.find_by_id(params[:id])
    authorize(@assessment)
    @assessment.try(:destroy)
    redirect_to assessments_path, notice: "Assessment was deleted"
  end

  def assessment_params
    params.require(:assessment).permit(:name, :time_allowed_in_minutes, :markdown, :css)
  end


end
