module FeatureHelpers

  def sign_in(user)
    mock_omniauth(
      base_overrides: { uid: user.github_id },
      info_overrides: {
        email: user.email,
        nickname: user.email.sub('@', '.')
      }
    )

    visit root_path
    click_on I18n.t('nav.sign_in')
  end

end
