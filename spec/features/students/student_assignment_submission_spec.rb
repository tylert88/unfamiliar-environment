require "rails_helper"

feature "students can submit assignments" do
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

  scenario "student can submit an assigned assignment with a url and number of minutes spent" do
    assignment = create_assignment(cohort_id: cohort.id)
    sign_in(student)

    click_on("Class Work")
    click_on("Assignment Submissions")

    click_on "Submit Assignment"

    fill_in "Submission url", with: "http://github.com"
    fill_in "Time to complete in minutes", with: "16"

    click_on "Update Assignment submission"

    expect(page).to have_content("Assignment Submitted")
  end
end
