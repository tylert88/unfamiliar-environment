module OmniauthHelpers
  def mock_omniauth(base_overrides: {}, info_overrides: {})
    info_defaults = {
      email: 'user@example.com',
      nickname: 'nickname',
    }

    base_defaults = {
      provider: 'github',
      uid: '123545',
      credentials: OmniAuth::AuthHash.new(token: 'abc123'),
      info: info_defaults.merge(info_overrides)
    }
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(base_defaults.merge(base_overrides))
  end
end
