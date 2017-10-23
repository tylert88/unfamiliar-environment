require "rails_helper"

feature "Writeup topics" do
  let!(:cohort) { create_cohort }
  let!(:instructor) {
    create_instructor(
      first_name: "Instructor",
      last_name: "User",
      github_id: '987',
    )
  }
  let!(:student) {
    create_student(
      cohort,
      first_name: "The",
      last_name: "Student",
    )
  }

  scenario "instructors manage writeup topics" do
    sign_in(instructor)

    click_on("Cohorts")
    click_on(cohort.name, match: :first)
    click_on("Writeup Topics")
    click_on("New Topic")

    fill_in "Subject", with: "What is a rainbow?"
    fill_in "Description", with: "Describe in detail"
    check "Active"
    click_on "Create Writeup topic"

    expect(page).to have_content("What is a rainbow?")

    click_on "What is a rainbow?"
    expect(page).to have_content("The following students have not completed the writeup")
    within('.students-who-did-not-complete') do
      expect(page).to have_content("The Student")
    end
  end
end
