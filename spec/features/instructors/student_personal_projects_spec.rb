require "rails_helper"

feature "Student adding a personal project" do
  scenario "adding and editing the personal project" do
    cohort = create_cohort(:name => "Cohort Name")

    student = create_student(
      cohort,
      first_name: "Bob",
      last_name: "Builder"
    )

    StudentProject.create!(
      user: student,
      name: "Some personal project",
      description: "This is a long description",
      github_url: "http://github.com/gSchool",
    )

    create_instructor(
      :first_name => "Jeff",
      :last_name => "Taggart",
      :email => "user@example.com"
    )

    mock_omniauth
    visit root_path
    click_on I18n.t('nav.sign_in')

    visit cohorts_path
    click_link cohort.name, match: :first

    click_on "Bob Builder"

    expect(page).to have_content("Some personal project")
    expect(page).to have_content("This is a long description")
    expect(page).to have_link("http://github.com/gSchool")

  end
end
