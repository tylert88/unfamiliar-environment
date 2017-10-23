module Api
  class AppsController < ActionController::Base

    APP_TOKENS = {
      snippets: Rails.application.config.snippet_app_auth_token
    }

    def authenticate
      app_name = params[:app_name]
      auth_token = request.headers['HTTP_X_APP_AUTH_TOKEN']
      user = User.find_by_github_username(params[:github_username])

      if APP_TOKENS[app_name.to_sym] && user && user.active?
        json = {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          role: user.role,
          status: user.status,
          auth_token: user.auth_token,
        }

        if user.current_cohort
          json[:cohort] = {
            id: user.current_cohort.id,
            name: user.current_cohort.name,
            url: cohort_url(user.current_cohort)
          }
        end

        render json: json, serializer: nil
      else
        render nothing: true, status: :unauthorized
      end
    end

  end
end
