module Api
  class BaseController < ActionController::Base
    include UserSessionHelper

    before_action do
      auth_token = request.headers['HTTP_X_AUTH_TOKEN']
      user = User.find_by_auth_token(auth_token)

      if !user_session.signed_in? && user.nil?
        render nothing: true, status: :unauthorized
      end
    end

    def me
      expires_now

      json = {
        user: {
          id: current_user.id,
          first_name: current_user.first_name,
          last_name: current_user.last_name,
          role: current_user.role,
          status: current_user.status,
          auth_token: current_user.auth_token,
        },
      }

      unless current_user.user?
        json[:cohorts] = Cohort.current.map{|cohort|
          {
            id: cohort.id,
            name: cohort.name,
            url: cohort_path(cohort)
          }
        }
      end

      render json: json, serializer: nil
    end
  end
end
