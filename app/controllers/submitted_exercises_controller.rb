class SubmittedExercisesController < ApplicationController
  def generate_dot_file
    auth_hash = {
      "auth_token" => current_user.auth_token,
      "url" => ENV['STUDENT_CHALLENGES_URL']
    }

    send_data( auth_hash.to_json, :filename => ".gschool.json" )

    flash[:notice] = "File successfully downloaded!"
  end
end