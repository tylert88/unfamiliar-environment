class SessionsController < PublicController

  def new
    @user = User.new
  end

  def sign_in_with_password
    @user = User.where('lower(email) = ?', params[:session][:email].to_s.downcase.strip).first
    if @user && @user.password_digest? && @user.authenticate(params[:session][:password])
      sign_user_in(@user)
    else
      @user ||= User.new(email: params[:session][:email])
      @user.errors[:base] << "Invalid email / password"
      render :new
    end
  end

  def create
    if params[:provider] == 'google_oauth2'
      login_from_google
    else
      login_from_website
    end
  end

  def destroy
    user_session.sign_out
    redirect_to root_path
  end

  def failure
    flash[:alert] = I18n.t("login_failed")
    redirect_to root_path
  end

  def set_password
    @user = User.new
  end

  def update_password
    id, time = Rails.application.message_verifier('set_password').verify(params[:verifier])
    user = User.find_by(id: id)
    if user && user.email.downcase == params[:user][:email].to_s.downcase.strip
      user.password = params[:user][:password]
      user.password_confirmation = params[:user][:password_confirmation]
      if user.save
        sign_user_in(user)
      else
        user.email = nil
        @user = user
        render :set_password
      end
    else
      user ||= User.new(email: params[:user][:email])
      user.email = nil
      user.errors[:base] << "Email is invalid"
      @user = user
      render :set_password
    end
  end

  private

  def login_from_google
    if request.env['omniauth.auth']['extra']['raw_info']['hd'] == 'galvanize.com'
      info = request.env['omniauth.auth']['info']

      user = User.find_by(email: info['email'])
      unless user
        user = User.create!(
          first_name: info['first_name'],
          last_name: info['last_name'],
          email: info['email'],
          role: :galvanizer,
          status: :active,
        )
      end
      sign_user_in(user)
    else
      notice = I18n.t('access_denied')
      redirect_to root_path, notice: notice
    end
  end

  def login_from_website
    github_id = request.env['omniauth.auth']['uid']
    github_info = request.env['omniauth.auth']['info'].merge('id' => github_id)

    user = FindAndUpdateUserFromGithubInfo.call(github_info)

    if user.present?
      session[:access_token] = request.env['omniauth.auth']['credentials']['token']
      sign_user_in(user)
    else
      notice = I18n.t('access_denied')
      redirect_to root_path, notice: notice
    end
  end

  def sign_user_in(user)
    user_session.sign_in(user)
    notice = I18n.t("welcome_message", :first_name => user.first_name, :last_name => user.last_name)
    redirect_to get_home_path, notice: notice
  end
end
