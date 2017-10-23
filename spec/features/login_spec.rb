require "rails_helper"

feature "Login" do
  scenario "allows a student to log in with github and log out" do
    create_student(
      create_cohort,
      first_name: "Github",
      last_name: "User",
      email: "user@example.com"
    )

    mock_omniauth

    visit root_path
    click_on I18n.t("nav.sign_in")
    within ".alert.alert-success" do
      expect(page).to have_content(I18n.t("welcome_message", first_name: "Github", last_name: "User"))
    end

    expect(page).to have_content("There is no plan for this day yet")
    expect(page).to have_content("ZPD Responses")

    click_on I18n.t("nav.sign_out")

    expect(page).to have_link(I18n.t("nav.sign_in"))
  end

  scenario "allows an instructor to log in with github and log out" do
    create_cohort(name: "Denver 2014")
    create_instructor(first_name: "Instructor", last_name: "User", email: "user@example.com")

    mock_omniauth

    visit root_path
    click_on I18n.t("nav.sign_in")

    expect(page).to have_content(I18n.t("welcome_message", first_name: "Instructor", last_name: "User"))

    click_on "Denver 2014", match: :first
    expect(page).to have_content("Denver 2014 Dashboard")

    click_on I18n.t("nav.sign_out")

    expect(page).to have_link(I18n.t("nav.sign_in"))
  end

  scenario "displays a unauthorized message if the user does not have a record in the db" do
    mock_omniauth

    visit root_path
    click_on I18n.t("nav.sign_in")

    within ".flash" do
      expect(page).to have_content(I18n.t("access_denied"))
    end
  end

  scenario "displays a unauthorized message if the user is inactive" do
    create_instructor(first_name: "Instructor", last_name: "User", email: "user@example.com", status: :inactive)

    mock_omniauth

    visit root_path
    click_on I18n.t("nav.sign_in")

    expect(page).to have_content(I18n.t("access_denied"))
  end

  scenario "redirects to the root path when oauth fails" do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials

    visit root_path
    click_on I18n.t("nav.sign_in")

    within ".flash" do
      expect(page).to have_content(I18n.t("login_failed"))
    end
  end
end
