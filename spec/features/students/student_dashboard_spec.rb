require "rails_helper"

describe "student dashboard" do
  it "displays daily plans, zpd responses, and objectives" do
    cohort = create_cohort(:name => "The Rebel Alliance")

    user = create_student(
      cohort,
      first_name: "Luke",
      last_name: "Skywalker",
      email: "luke@skywalker.com",
    )

    mock_omniauth(:info_overrides => {:nickname => "luke_skywalker"})
    sign_in(user)
    expect(page).to have_content("Student Dashboard")
    expect(page).to have_content("Please fill out a ZPD Response for today")

    daily_plan = create_daily_plan(cohort_id: cohort.id)
    zpd_response = create_zpd_response(user_id: user.id)

    click_on "Daily Information"

    expect(page).to have_link("View Full Plan")
    expect(page).to have_content(ZpdResponse::RESPONSES[zpd_response.response])
  end
end
