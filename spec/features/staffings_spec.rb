require "rails_helper"

feature "Staffings" do
  let!(:cohort) { create_cohort }
  let!(:instructor) {
    create_instructor(
      :first_name => "Instructor",
      :last_name => "User",
      :github_id => '987',
    )
  }

  scenario "instructors manage staffings" do
    sign_in(instructor)

    click_on("Cohorts")
    click_on(cohort.name, match: :first)
    click_on("Staffings")
    click_on("New Staffing")

    select(instructor.full_name, :from => "User")
    select("active", :from => "Status")

    click_on "Create Staffing"

    expect(page).to have_content(instructor.full_name)

    within ".table" do
      click_link "edit"
    end

    select("inactive", :from => "Status")

    click_on "Update Staffing"

    expect(page).to have_content("inactive")

    within ".table" do
      click_link "delete"
    end

    expect(page).to have_no_content("inactive")
  end

end
