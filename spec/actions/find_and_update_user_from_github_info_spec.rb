require "rails_helper"

describe FindAndUpdateUserFromGithubInfo do
  it "returns nil when passed an empty hash" do
    create_user(:email => "user@example.com")

    found_user = FindAndUpdateUserFromGithubInfo.call({})

    expect(found_user).to be_nil
  end

  describe "when only email is present" do
    it "finds user when github id is not present" do
      user = create_user(:email => "user@example.com")

      found_user = FindAndUpdateUserFromGithubInfo.call(
        "email" => "user@example.com",
        "nickname" => "some nickname",
        "id" => "2342112"
      )

      expect(found_user).to eq user
    end

    it "updates the users nickname and id" do
      create_user(:email => "user@example.com", github_id: '2342112')

      found_user = FindAndUpdateUserFromGithubInfo.call(
        "email" => "user@example.com",
        "nickname" => "github_username",
        "id" => "2342112"
      )

      expect(found_user.email).to eq("user@example.com")
      expect(found_user.github_username).to eq("github_username")
      expect(found_user.github_id).to eq("2342112")

    end

    it "finds user even if case is mismatched" do
      user = create_user(:email => "user@example.com")

      found_user = FindAndUpdateUserFromGithubInfo.call(
        "email" => "USER@example.com",
        "id" => "2342112"
      )

      expect(found_user).to eq user
    end
  end

  describe "when both email and github id are present" do
    it "finds user" do
      user = create_user(:email => "user@example.com", :github_id => "2342112")

      found_user = FindAndUpdateUserFromGithubInfo.call(
        "email" => "user@example.com",
        "id" => "2342112"
      )

      expect(found_user).to eq user
    end

    it "finds user even if email is different on github" do
      user = create_user(:email => "user@example.com", :github_id => "2342112")

      found_user = FindAndUpdateUserFromGithubInfo.call(
        "email" => "anotherEmail@example.com",
        "id" => "2342112"
      )

      expect(found_user).to eq user
    end

    it "updates the user's username" do
      create_user(
        :email => "user@example.com",
        :github_username => "some_username",
        :github_id => "2342112"
      )

      found_user = FindAndUpdateUserFromGithubInfo.call(
          "email" => "anotherEmail@example.com",
          "nickname" => "some_new_username",
          "id" => "2342112"
        )

      expect(found_user.github_username).to eq("some_new_username")
    end

    it "updates the users email address" do
      create_user(
        :email => "user@example.com",
        :github_username => "some_username",
        :github_id => "2342112"
      )

      found_user = FindAndUpdateUserFromGithubInfo.call(
        "email" => "anotherEmail@example.com",
        "nickname" => "some_new_username",
        "id" => "2342112"
      )

      expect(found_user.email).to eq("anotherEmail@example.com")
    end
  end

  describe "when both email and github username are present" do
    it "finds the user based on their github username" do
      user = create_user(:email => "foo@example.com", :github_username => "zippy")

      found_user = FindAndUpdateUserFromGithubInfo.call(
        "email" => "user@example.com",
        "nickname" => "zippy"
      )

      expect(found_user).to eq user
    end
  end
end
