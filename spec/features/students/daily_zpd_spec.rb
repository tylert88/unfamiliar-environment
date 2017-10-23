require "rails_helper"

feature "Students can create a daily ZPD response" do
  scenario "student adds a ZPD" do
    @cohort = create_cohort(:name => "The Rebel Alliance")

    user = create_student(
      @cohort,
      first_name: "Luke",
      last_name: "Skywalker",
      email: "luke@skywalker.com",
    )

    mock_omniauth(:info_overrides => {:nickname => "luke_skywalker"})
    sign_in(user)

    visit root_path
    click_on "ZPD Responses"

    click_on "Today's Response"
    select "Too Easy!", from: "Response"

    click_on "Submit"

    expect(page).to have_content "ZPD Successfully Submitted"
  end
end
