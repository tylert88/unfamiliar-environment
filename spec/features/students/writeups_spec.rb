require "rails_helper"

feature "Students can write in-class writeups in lessons" do
  scenario "student adds a writeup" do
    @cohort = create_cohort(:name => "Cohort Name")

    WriteupTopic.create!(
      cohort: @cohort,
      subject: "What actions are there in CRUD?",
    )

    create_student(
      @cohort,
      first_name: "Jeff",
      last_name: "Taggart",
      email: "user@example.com",
    )

    mock_omniauth(:info_overrides => {:nickname => "some_user"})

    visit root_path
    click_on I18n.t("nav.sign_in")
    click_on "Writeups"
    fill_in "writeup_response", with: "index,show,new,create,edit,update,destroy"
    click_on "Create Writeup"

    expect(page).to have_content("index,show,new,create,edit,update,destroy")
    expect(page).to have_content("What actions are there in CRUD?")
  end
end
