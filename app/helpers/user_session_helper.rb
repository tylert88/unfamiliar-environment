module UserSessionHelper
  def sign_in_using_github_path
    "/auth/github"
  end

  def current_user
    user_session.current_user
  end

  def user_session
    @user_session ||= UserSession.new(session)
  end

  def require_signed_in_user
    if !user_session.signed_in?
      flash[:notice] = I18n.t('signed_in_user_required_for_page')
      redirect_to root_path
    end
  end
end
