module ControllerHelpers

  def sign_in(user = create_user(first_name: 'Joe', last_name: 'Example'))
    user_session = UserSession.new('user_id' => user.id)
    allow(controller).to receive(:user_session).and_return(user_session)
    user
  end

end