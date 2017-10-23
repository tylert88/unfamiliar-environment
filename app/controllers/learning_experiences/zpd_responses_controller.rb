class LearningExperiences::ZpdResponsesController < ApplicationController
  def index
    @learning_experience = LearningExperience.find(params[:learning_experience_id])
    @zpd_response_data = ZpdResponse.gather_data_for_resource(@learning_experience)
    @zpd_responses = ZpdResponse.where(resource: @learning_experience)
    authorize(@zpd_responses)
  end

  def new
    @learning_experience = LearningExperience.find(params[:learning_experience_id])
    @zpd_response = ZpdResponse.new
  end

  def create
    learning_experience = LearningExperience.find(params[:learning_experience_id])
    @zpd_response = ZpdResponse.new(zpd_response_params.merge(resource: learning_experience, user_id: current_user.id))

    if @zpd_response.save
      redirect_to user_learning_experiences_path(current_user), notice: "ZPD Response successfully saved"
    else
      flash[:alert] = "Something went wrong"
      redirect_to user_learning_experiences_path(current_user)
    end
  end

  private

  def zpd_response_params
    params.require(:zpd_response).permit(:date, :response)
  end
end