require "rails_helper"

feature "Student Exercises" do
  before do
    @cohort = create_cohort(name: "Cohort Name")
    @user = create_student(
      @cohort,
      first_name: "Jeff",
      last_name: "Taggart",
      email: "user@example.com",
    )
    mock_omniauth

    visit root_path
    click_on I18n.t("nav.sign_in")
  end

  scenario "allows a student to submit an exercise" do
    CohortExercise.create!(
      cohort: @cohort,
      exercise: create_exercise(name: "Arrays and things", tag_list: "ruby, arrays")
    )

    click_on "Exercises"

    within("tr", text: "Arrays and things") do
      expect(page).to have_no_content("✓")
      expect(page).to have_content("ruby")
      expect(page).to have_content("arrays")
      click_on "Arrays and things"
    end

    expect(page).to have_content("Arrays and things")
    expect(page).to have_content("ruby")
    expect(page).to have_content("arrays")
    expect(page).to have_no_link("Tracker Project")
    expect(page).to have_content("You have not submitted a solution")

    click_on "Submit Code"

    fill_in "GitHub Repo Name", with: "some_completed_exercise"
    fill_in "Tracker Project URL", with: "http://www.pivotaltracker.com"
    click_on "Submit"

    expect(page).to have_content("Arrays and things")
    expect(page).to have_content("You've submitted: some_completed_exercise")
    expect(page).to have_link("Tracker Project")
    expect(page).to have_no_content("Submit Code")

    click_on "Exercises"

    within("tr", text: "Arrays and things") do
      expect(page).to have_content("✓")
    end
  end

  scenario "a student can edit their answer to an exercise" do
    exercise = create_exercise(name: "Arrays and things", tag_list: "ruby, arrays")
    CohortExercise.create!(
      cohort: @cohort,
      exercise: exercise,
    )

    Submission.create!(
      user: @user,
      exercise: exercise,
      github_repo_name: "submission",
    )

    click_on "Exercises"
    click_on "Arrays and things"
    click_on "Edit"
    fill_in "GitHub Repo Name", with: "other_submission"
    click_on "Submit"

    expect(page).to have_content "other_submission"
  end

  scenario "lists all exercises for the students cohort" do
    CohortExercise.create!(
      cohort: @cohort,
      exercise: create_exercise(name: "Arrays and things")
    )

    CohortExercise.create!(
      cohort: @cohort,
      exercise: create_exercise(name: "Another exercise")
    )

    CohortExercise.create!(
      cohort: create_cohort,
      exercise: create_exercise(name: "Shouldn't be there")
    )

    click_on "Exercises"

    expect(page).to have_content("Arrays and things")
    expect(page).to have_content("Another exercise")
    expect(page).to have_no_content("Shouldn't be there")
  end
end
