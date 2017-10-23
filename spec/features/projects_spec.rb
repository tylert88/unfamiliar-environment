require "rails_helper"

feature "Student adding a project" do
  scenario "adding and editing a project" do
    @cohort = create_cohort(:name => "Cohort Name")
    create_student(
      @cohort,
      first_name: "Ed",
      last_name: "Smith",
      email: "user@example.com",
    )
    mock_omniauth(:info_overrides => {:nickname => "some_user"})

    visit root_path
    click_on I18n.t("nav.sign_in")
    click_on "Projects"

    click_on("New Project")
    fill_in "Name", :with => "New Awesome App"
    fill_in "Description", :with => "This is a description of my application. This needs a lot of words to be valid"
    fill_in "GitHub URL", :with => "http://github.com/foo"
    fill_in "Tracker URL", :with => "http://pivotaltracker.com/foo"
    fill_in "Production URL", :with => "http://example.com/"
    fill_in "Technical notes", :with => "Here are some notes"
    click_on "Save"

    expect(page).to have_content("Project Created")
    expect(page).to have_content("New Awesome App")
    expect(page).to have_content("This is a description of my application. This needs a lot of words to be valid")
    expect(page).to have_content("http://github.com/foo")
    expect(page).to have_content("http://pivotaltracker.com/foo")
    expect(page).to have_content("http://example.com/")

    click_on "Edit"
    fill_in "Name", :with => "An even better name"
    click_on "Save"

    expect(page).to have_content("Project Saved")
    expect(page).to have_content("An even better name")
  end
end
