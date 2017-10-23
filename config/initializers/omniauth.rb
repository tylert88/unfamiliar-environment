Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], :scope => "user:email"
  configure do |config|
    # If you don't have this, logging in from a non-ssl page
    # results in an auth failure because the redirect URI registered
    # with Github is ssl and the redirect URI sent to Github will not
    # be SSL.
    config.full_host = Students::Application.config.github_oauth_full_host
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]
end

OmniAuth.config.logger = Rails.logger
