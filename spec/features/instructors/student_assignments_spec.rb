require "rails_helper"

feature "admin can assign StudentAssignments to students" do
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

  scenario "admin can assign a global assignments to a cohort" do
    sign_in(instructor)

    click_on("Cohorts")
    click_on(cohort.name, match: :first)
    click_on("Assignments")
    click_on("New Assignment")

    fill_in "Name", with: "Bootstrap Assignment"
    fill_in "Due date", with: "02/04/2015"
    fill_in "Url", with: "http://github.com"

    click_on "Create Assignment"

    AssignmentSubmission.last.update_attributes(submitted: true, time_spent: 48)

    expect(page).to have_content "04/02/2015"
    click_on "Bootstrap Assignment"

    expect(page).to have_content "The Student"
    expect(page).to have_content "48"

    click_on "Add Note"

    fill_in "Content", with: "That is some good foo!"

    click_on "Add Note"

    expect(page).to have_content "Note successfully added"
  end
end
