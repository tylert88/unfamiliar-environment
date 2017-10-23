require "rails_helper"

feature "Daily Plans" do
  let!(:cohort) { create_cohort }
  let!(:student) {
    create_student(
      cohort,
      first_name: "Student",
      last_name: "User",
      github_id: "abc123"
    )
  }

  scenario "students see action plans" do
    DailyPlan.create!(
      date: Date.current,
      cohort: cohort,
      description: "# Some header"
    )

    sign_in(student)
    expect(page).to have_content("Some header")
    expect(page).to have_no_css(".page-header .pull-right .btn", text: "Edit")

    click_on("Daily Plans", match: :first)
    expect(page).to have_no_content("New Daily Plan")
  end

end
