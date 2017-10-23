module Api
  class SubmissionsController < ActionController::Base

    def index
      cohort_exercise = CohortExercise.find(params[:cohort_exercise_id])
      submissions = cohort_exercise.submissions.map do |submission|
        {
          id: submission.id,
          github_username: submission.user.github_username,
          user_id: submission.user.id,
          exercise_id: submission.exercise_id,
          github_repo_name: submission.github_repo_name,
        }
      end

      render json: submissions.to_json
    end

  end
end
