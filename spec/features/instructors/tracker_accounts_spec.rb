require "rails_helper"

feature "Cohorts" do
  let!(:instructor) {
    create_instructor(:first_name => "Instructor", :last_name => "User", :github_id => '987')
  }

  let!(:cohort) { create_cohort }

  scenario "an instructor sets up tracker accounts for all students in the cohort" do
    VCR.use_cassette('features/instructor/tracker_accounts/create') do
      student = create_student(
        cohort,
        first_name: "Joe",
        last_name: "Example",
        email: "joe@example.com"
      )
      sign_in(instructor)

      click_on("Cohorts")
      click_on(cohort.name, match: :first)
      click_on("Tracker Accounts")
      within("tbody tr") do
        expect(page).to have_content("Joe Example")
        expect(page).to have_content("joe@example.com")
        expect(page).to have_content("Not a member")
      end
      click_on("Create Accounts")
      expect(page).to have_content("Tracker accounts were created successfully")
    end
  end
end
