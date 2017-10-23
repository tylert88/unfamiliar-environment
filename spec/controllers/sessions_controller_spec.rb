require 'rails_helper'

describe SessionsController do

  it "rejects attempts to save passwords that don't match" do
    user = create_user
    verifier = Rails.application.message_verifier('set_password').generate(user.id)

    expect do
      post :update_password, verifier: verifier, user: {
        email: user.email,
        password: 'foo',
        password_confirmation: 'bar'
      }
    end.to_not change{ user.reload.password_digest }

    expect(response).to be_success
  end

  it "rejects attempts to save passwords when email doesn't match verifier" do
    user = create_user
    verifier = Rails.application.message_verifier('set_password').generate(user.id)

    expect do
      post :update_password, verifier: verifier, user: {
        email: 'foo@bar.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end.to_not change{ user.reload.password_digest }

    expect(response).to be_success
  end

  it "rejects attempts to save passwords when verifier is wrong" do
    user = create_user
    verifier = Rails.application.message_verifier('set_password').generate(-1)

    expect do
      post :update_password, verifier: verifier, user: {
        email: 'foo@bar.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end.to_not change{ user.reload.password_digest }

    expect(response).to be_success
  end

end
