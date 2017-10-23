require "rails_helper"

feature "Instructor cohorts" do

  let!(:cohort) { create_cohort(:name => 'Boulder Galvanize') }
  let!(:instructor) { create_instructor(:first_name => "Instructor", :last_name => "User", :github_id => '987') }
  let!(:student) {
    create_student(
      cohort,
      first_name: "Student",
      last_name: "User",
      github_id: '123',
      github_username: "Student12345"
    )
  }

  scenario "instructor is able to view the cohorts" do
    sign_in(instructor)

    visit cohorts_path

    expect(page).to have_content(cohort.name)
  end

  scenario "non-instructors cannot see the instructor cohorts" do
    visit cohorts_path
    expect(page).to have_content("Please sign in to access that page")
    expect(page.current_path).to_not eq(cohorts_path)

    sign_in(student)

    visit cohorts_path
    expect(page.current_path).to_not eq(cohorts_path)
  end

  scenario "instructor can see a list of students (not instructors) and a link to their github repository" do
    create_student(
      cohort,
      first_name: "Student",
      last_name: "Without github"
    )

    sign_in(instructor)

    visit cohorts_path

    click_on 'Boulder Galvanize', match: :first

    within "tr", :text => "Student User" do
      expect(page).to have_link("Student12345")
    end

    within ".table" do
      expect(page).to have_no_content("Instructor User")
    end
  end

end
