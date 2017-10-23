class UserSession
  def initialize(rails_session)
    @rails_session = rails_session
  end

  def sign_in(user)
    rails_session['user_id'] = user.id
  end

  def sign_out
    rails_session['user_id'] = nil
  end

  def signed_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.active.find_by_id(rails_session['user_id'])
  end

  private
  attr_reader :rails_session
end
