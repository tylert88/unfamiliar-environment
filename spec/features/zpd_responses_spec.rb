require "rails_helper"

feature "ZPD Responses" do
  let!(:curriculum) { create_curriculum}
  let!(:cohort) { create_cohort(curriculum_id: curriculum.id) }
  let!(:instructor) {
    create_instructor(
      :first_name => "Instructor",
      :last_name => "User",
      :github_id => '987'
    )
  }

  let!(:student) { create_student(cohort) }

  scenario "can be filled out for learning experiences" do
    learning_experience = create_learning_experience(curriculum_id: curriculum.id)

    sign_in(student)

    visit user_learning_experience_path(student, learning_experience)

    click_on "New ZPD Response"

    select "Too Easy!", from: "Response"

    click_on "Submit"

    expect(page).to have_content("ZPD Response successfully saved")

    visit user_learning_experience_path(student, learning_experience)

    expect(page).to have_content("You rated this Learning Experience Too Easy!")

    visit new_learning_experience_zpd_response_path(learning_experience)

    select "Too Easy!", from: "Response"

    click_on "Submit"

    expect(page).to have_content("Something went wrong")

    click_on student.full_name
    click_on "Sign Out"

    sign_in(instructor)

    visit curriculum_learning_experience_path(learning_experience.curriculum, learning_experience)

    click_on "ZPD Responses"

    expect(page).to have_content "Too Easy!"
  end
end