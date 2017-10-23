require "rails_helper"

feature "Merging objectives" do
  let!(:cohort) { create_cohort }
  let!(:instructor) {
    create_instructor(
      :first_name => "Instructor",
      :last_name => "User",
    )
  }

  scenario "instructors can add employer to a student" do
    user = create_student(cohort)
    curriculum = create_curriculum
    standard = create_standard(curriculum: curriculum)
    objective1 = create_objective(standard: standard)
    objective2 = create_objective(standard: standard)
    objective3 = create_objective(standard: standard)

    sign_in(instructor)

    visit curriculum_path(curriculum)
    click_on(standard.name)

    check("objective_#{objective1.id}")
    check("objective_#{objective2.id}")
    fill_in "New Objective Name", with: "New objective name"
    click_button "Merge"

    expect(page).to_not have_selector('a', text: objective1.name)
    expect(page).to_not have_selector('a', text: objective2.name)
    expect(page).to have_content("New objective name")
  end

end
