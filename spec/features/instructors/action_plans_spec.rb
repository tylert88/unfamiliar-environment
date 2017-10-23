require "rails_helper"

feature "Action Plans" do
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
      first_name: "Student",
      last_name: "User",
    )
  }

  scenario "instructors can create action plans for students" do
    ActionMailer::Base.deliveries = []
    curriculum = create_curriculum(name: "js")
    cohort.update!(curriculum_id: curriculum.id)
    create_learning_experience(name: "jQuery", curriculum: curriculum)
    sign_in(instructor)

    click_on("Cohorts")
    click_on(cohort.name, match: :first)
    click_on("Action Plans")
    click_on("Student User")
    click_on("New Entry")

    fill_in "Description", with: "# Some header"
    expect do
      click_on "Create Action plan entry"
    end.to change{ActionMailer::Base.deliveries.length}.by(1)

    expect(page).to have_css(".panel h1", text: "Some header")

    within('.panel'){ click_on("Edit") }

    fill_in "Description", with: "* some list"
    fill_in "Started on", with: "12/12/2015"
    fill_in "Due on", with: "1/12/2015"
    fill_in "Completed on", with: "1/15/2015"
    select("Unstarted", from: "Status")
    select("jQuery", from: "Learning experience")

    expect do
      click_on "Update Action plan entry"
    end.to change{ActionMailer::Base.deliveries.length}.by(1)

    expect(page).to have_css(".panel li", text: "some list")

    within('.panel'){ click_on("Delete") }

    expect(page).to have_no_css(".panel li", text: "some list")
  end

end
