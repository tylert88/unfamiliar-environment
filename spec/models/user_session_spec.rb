require 'rails_helper'

describe UserSession do
  let (:rails_session) { Hash.new }
  let (:user_session) { UserSession.new(rails_session) }

  describe "signing in" do
    before do
      expect(user_session).to_not be_signed_in
    end
    it 'knows if a user is signed in from the session' do
      user = create_user
      rails_session['user_id'] = user.id
      expect(user_session).to be_signed_in
    end

    it 'knows the user is signed in after signing in the user' do
      user = create_user

      user_session.sign_in(user)
      expect(user_session).to be_signed_in
    end
  end

  it 'allows a user to sign out' do
    user = User.new(id: 123)

    user_session.sign_in(user)
    user_session.sign_out

    expect(user_session).to_not be_signed_in
  end

  it 'can get the logged in user' do
    user = create_student(
      create_cohort,
      first_name: "Bob",
      last_name: "Smith",
      email: "bob@example.com",
    )

    user_session.sign_in(user)

    expect(user_session.current_user).to eq user
  end
end
