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

  scenario "instructors can add employer to a student" do
    user = create_student(cohort)

    sign_in(instructor)

    visit cohort_path(cohort)
    click_link(user.full_name)
    click_on("Add Employment", match: :first)
    fill_in("Company name", :with => "Awesomeness.io")
    click_on("Create Employment")

    expect(page).to have_content("Awesomeness.io")

    within('.panel-employment') do
      click_on "edit"
    end
    uncheck("Active")
    click_on("Update Employment")
    expect(page).to have_content("Awesomeness.io")

    within('.panel-employment') do
      click_on "delete"
    end
    expect(page).to have_content("Employment was deleted")
  end

end
