require "rails_helper"

feature "Users" do
  let!(:cohort) { create_cohort }
  let!(:instructor) {
    create_instructor(
      :first_name => "Instructor",
      :last_name => "User",
      :github_id => '987'
    )
  }

  scenario "instructors manage users" do
    sign_in(instructor)

    click_on("Users")
    click_on("New User")

    fill_in("First name", :with => "Joe")
    fill_in("Last name", :with => "Example")
    fill_in("Email", :with => "joe@example.com")
    select("user", :from => "Role")
    select("active", :from => "Status")
    select(cohort.name, :from => "Cohort")

    click_on "Create User"

    expect(page).to have_content("Joe Example")
  end

end
