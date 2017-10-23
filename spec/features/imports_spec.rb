require "rails_helper"

feature "Imports" do
  let!(:cohort) { create_cohort }
  let!(:instructor) {
    create_instructor(
      :first_name => "Instructor",
      :last_name => "User",
      :github_id => '987',
    )
  }

  scenario "instructors import students" do
    ActionMailer::Base.deliveries = []
    sign_in(instructor)

    click_on("Cohorts")
    click_on(cohort.name, match: :first)
    click_on("Import")

    csv_text = CSV.generate do |csv|
      csv << ["first_name","last_name","email","city","state","address","phone", "github_username"]
      csv << ["Joe","Example","joe@example.com","San Francisco","CA",nil,nil,"zippy"]
      csv << ["Jane","Example","jane@example.com","San Francisco","CA",nil,nil,"zappy"]
    end

    fill_in "Paste your csv text here...", with: csv_text

    select("GitHub", from: "invitation_type")
    click_button "Import"

    expect(page).to have_content("2 students were imported successfully")
    expect(ActionMailer::Base.deliveries.length).to eq(2)

    within ".table" do
      expect(page).to have_content("Joe")
      expect(page).to have_content("Example")
      expect(page).to have_content("Jane")
    end

    expect(User.find_by_email("joe@example.com").github_username).to eq("zippy")
    expect(User.find_by_email("jane@example.com").github_username).to eq("zappy")
  end

  scenario "instructors can see error messages for failed rows" do
    ActionMailer::Base.deliveries = []
    sign_in(instructor)

    click_on("Cohorts")
    click_on(cohort.name, match: :first)
    click_on("Import")

    create_user(email: "joe@example.com")

    csv_text = CSV.generate do |csv|
      csv << ["first_name","last_name","email","city","state","address","phone"]
      csv << ["Joe","Example","joe@example.com","San Francisco","CA",nil,nil]
    end

    fill_in "Paste your csv text here...", with: csv_text

    click_button "Import"

    expect(page).to have_content("Could not import 1 student")
    expect(ActionMailer::Base.deliveries.length).to eq(0)

    expect(page).to have_content("On line 1: Email has already been taken")
  end

end
