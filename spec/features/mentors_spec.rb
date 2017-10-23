require "rails_helper"

feature "Mentors" do
  let!(:cohort1) { create_cohort }
  let!(:cohort2) { create_cohort }

  let!(:student1) { create_student(cohort1, first_name: "Yes") }
  let!(:student2) { create_student(cohort2, first_name: "Nope") }

  let!(:mentor) { create_user(github_id: '987') }

  scenario "mentors can see daily plans for students they mentor currently" do
    Mentorship.create!(
      user: student1,
      mentor: mentor,
      status: :current,
    )
    Mentorship.create!(
      user: student2,
      mentor: mentor,
      status: :previous,
    )
    DailyPlan.create!( cohort: cohort1, description: 'Yup', date: Date.current )
    DailyPlan.create!( cohort: cohort2, description: 'Definitely not', date: Date.current )

    sign_in(mentor)

    expect(page).to have_content(student1.full_name)
    expect(page).to have_no_content(student2.full_name)

    click_on "Daily plans"
    expect(page).to have_content("Daily Plans")

    visit cohort_daily_plan_path(cohort1, Date.current)
    expect(page).to have_content("Yup")

    visit cohort_daily_plan_path(cohort2, Date.current)
    expect(page).to have_content("You do not have permission to access that page")
  end

end
