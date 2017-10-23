require "rails_helper"

feature "Instructor adding student photos" do
  before do
    @cohort = create_cohort(name: "Cohort Name")

    create_instructor(
      first_name: "Jeff",
      last_name: "Taggart",
      email: "user@example.com",
    )

    create_student(
      @cohort,
      first_name: "John",
      last_name: "Foley",
      email: "foley@example.com",
    )
    mock_omniauth

    visit root_path
    click_on I18n.t("nav.sign_in")
    click_on "Cohort Name", match: :first
  end

  scenario "Instructors can upload student photos" do
    click_on "John Foley"
    within('.page-header') do
      click_on "Edit"
    end
    attach_file "Avatar", Rails.root.join("spec", "fixtures", "avatar.jpg")
    click_on "Update User"

    expect(page).to have_selector("img[src$='avatar.jpg']")
  end
end
