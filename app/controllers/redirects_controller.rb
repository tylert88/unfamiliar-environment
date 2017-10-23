class RedirectsController < ApplicationController

  def learning_experience
    @learning_experience = LearningExperience.find_by_id(params[:id])
    if current_user.current_cohort || current_user.instructor?
      redirect_to user_learning_experience_path(current_user, @learning_experience)
    else
      redirect_to get_home_path, alert: "You can't access that learning experience"
    end
  end

end
