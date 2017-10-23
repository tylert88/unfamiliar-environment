require "rails_helper"

feature "Pair bingo" do
  scenario "users can record that they've paired with other students" do
    cohort = create_cohort(
      name: "Cohort Name"
    )

    student1 = create_student(
      cohort,
      first_name: "Student",
      last_name: "One",
      email: "user@example.com",
    )

    student2 = create_student(
      cohort,
      first_name: "Other",
      last_name: "Student",
      email: "user2@example.com",
    )

    student3 = create_student(
      cohort,
      first_name: "Third",
      last_name: "Student",
      email: "user3@example.com",
    )

    create_pairing(
      user: student3,
      pair: student1
    )

    mock_omniauth
    visit root_path
    click_on I18n.t("nav.sign_in")
    click_on "Pair Bingo"

    click_on "Other Student"
    fill_in "Paired on", with: "1/1/2014"
    fill_in "Feedback", with: "It was great"
    click_button "Create Pairing"

    expect(page).to have_content("Pairing was created successfully!")
    within(".text-translucent") do
      expect(page).to have_content("Other Student")
    end

    within(".pending-pairing") do
      fill_in "pairing_feedback", with: "It was great"
      click_button "Record feedback"
    end

    expect(page).to have_content("Pairing was created successfully!")
  end
end
