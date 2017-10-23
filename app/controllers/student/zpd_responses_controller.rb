class Student::ZpdResponsesController < ApplicationController
  def index
    @zpd_responses = ZpdResponse.where(user_id: current_user.id).reverse_order
    @zpd_response_data = ZpdResponse.gather_data_for_user(current_user.id)
  end

  def new
    @zpd_response = ZpdResponse.new
  end

  def create
    zpd_response = ZpdResponse.new(zpd_response_params.merge(user_id: current_user.id))
    if zpd_response.save
      redirect_to cohort_student_dashboard_path, notice: "ZPD Successfully Submitted"
    else
      @zpd_response = zpd_response
      render :new
    end
  end

  def edit
    @zpd_response = ZpdResponse.find(params[:id])
  end

  def update
    zpd_response = ZpdResponse.find(params[:id])
    if zpd_response.update(zpd_response_params)
      redirect_to cohort_zpd_responses_path, notice: "ZPD Successfully Updated"
    else
      @zpd_response = zpd_response
      render :edit
    end
  end

  private

  def zpd_response_params
    params.require(:zpd_response).permit(:response, :date)
  end
end
