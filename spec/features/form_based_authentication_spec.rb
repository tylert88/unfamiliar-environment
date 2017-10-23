require "rails_helper"

feature "Form-based authentication" do
  let!(:cohort) { create_cohort }
  let(:instructor) {
    create_instructor(
      first_name: "Instructor",
      last_name: "User",
    )
  }
  let(:student) {
    create_student(
      cohort,
      first_name: "Student",
      last_name: "User",
      password: 'my password'
    )
  }

  scenario "users can login with a password" do
    visit root_path
    click_on "Sign In w/ Password"

    fill_in("Email", :with => student.email)
    fill_in("Password", :with => "my password")
    click_button "Sign In"

    expect(page).to have_content("Welcome, Student User")
    expect(page).to have_content("Daily Plans")
  end

  scenario "does not log students in with invalid data" do
    visit root_path
    click_on "Sign In w/ Password"

    # no credentials
    click_button "Sign In"
    expect(page).to have_content("Invalid email / password")

    # email not in database
    fill_in("Email", :with => "foo@example.com")
    fill_in("Password", :with => "my password")
    click_button "Sign In"
    expect(page).to have_content("Invalid email / password")

    # password incorrect
    fill_in("Email", :with => student.email)
    fill_in("Password", :with => "wrong")
    click_button "Sign In"
    expect(page).to have_content("Invalid email / password")

    # logging in with an existing user that hasn't set a password
    fill_in("Email", :with => instructor.email)
    fill_in("Password", :with => "wrong")
    click_button "Sign In"
    expect(page).to have_content("Invalid email / password")
  end

  scenario "allows users to set their own passwords" do
    sign_in(instructor)
    click_on 'Edit Personal Information'
    fill_in('Password', with: 'password')
    click_on("Update Profile")
    click_on 'Sign Out'

    click_on "Sign In w/ Password"
    fill_in("Email", :with => instructor.email)
    fill_in("Password", :with => "password")
    click_button "Sign In"
    expect(page).to have_content("Welcome, Instructor User")

    click_on 'Edit Personal Information'
    click_on("Update Profile")
    click_on 'Sign Out'

    click_on "Sign In w/ Password"
    fill_in("Email", :with => instructor.email)
    fill_in("Password", :with => "password")
    click_button "Sign In"
    expect(page).to have_content("Welcome, Instructor User")
  end

  scenario "users can set their own passwords when they are invited" do
    sign_in(instructor)
    verifier = Rails.application.message_verifier('set_password').generate(instructor.id)
    visit set_password_url(verifier)

    fill_in("Email", :with => instructor.email)
    fill_in("Password", :with => "password")
    fill_in("Password confirmation", :with => "password")
    click_button "Set My Password"
  end

end
