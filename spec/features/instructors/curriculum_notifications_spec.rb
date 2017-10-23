require "rails_helper"

feature "curriculum notifications" do
  let(:instructor) { create_instructor(:first_name => "Instructor", :last_name => "User", :github_id => '987') }
  let!(:curriculum) { create_curriculum(name: "Full Stack") }
  scenario "display for creating and updating Standards and Objectives" do
    sign_in(instructor)

    visit new_curriculum_standard_path(curriculum)

    fill_in "Name", with: "Write large programs"
    fill_in "Tags", with: "JS"
    click_on "Create Standard"

    visit edit_standard_path(Standard.last)

    fill_in "Name", with: "Write small programs"

    click_on "Update Standard"

    visit new_standard_objective_path(Standard.last)

    fill_in "Name", with: "Use while loops!"
    click_on "Create Objective"

    visit edit_objective_path(Objective.last)

    fill_in "Name", with: "Use for loops"
    click_on "Update Objective"

    visit curriculum_path(curriculum)
    click_on "Activity"

    expect(page).to have_link("#{instructor.full_name} created the Standard: Write large programs.")
    expect(page).to have_link("#{instructor.full_name} updated the Standard: Write small programs.")
    expect(page).to have_link("#{instructor.full_name} created the Objective: Use while loops!.")
    expect(page).to have_link("#{instructor.full_name} updated the Objective: Use for loops.")

    visit new_curriculum_learning_experience_path(curriculum)

    fill_in "Name", with: "JS Fundamentals"

    click_on "Create Learning experience"

    visit edit_curriculum_learning_experience_path(curriculum, LearningExperience.last)

    fill_in "Name", with: "JS Intermediate"

    click_on "Update Learning experience"

    visit curriculum_path(curriculum)
    click_on "Activity"

    expect(page).to have_link("#{instructor.full_name} created the LearningExperience: JS Fundamentals.")
    expect(page).to have_link("#{instructor.full_name} updated the LearningExperience: JS Intermediate.")
  end
end