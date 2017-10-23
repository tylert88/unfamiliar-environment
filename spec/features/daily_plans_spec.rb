require 'rails_helper'

feature 'Daily Plans' do

  let(:cohort) { create_cohort }

  let(:cohort2) { create_cohort }

  let!(:student) {
    create_student(
      cohort,
      first_name: "Instructor",
      last_name: "User",
      github_id: '987',
    )
  }

  scenario "users can search for daily plans" do
    plan_to_find = create_daily_plan(cohort: cohort, description: "Sample 1")
    plan_to_hide = create_daily_plan(cohort: cohort2, description: "Sample 2")

    sign_in(student)
    fill_in "q", with: "Sample"
    click_on "search"

    expect(page).to have_content("Sample 1")
    expect(page).to have_no_content("Sample 2")
  end

end
