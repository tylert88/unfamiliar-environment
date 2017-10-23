require "rails_helper"

feature "instructor visiting a student dashboard" do
  let!(:cohort) { create_cohort(:name => 'Boulder Galvanize') }
  let!(:instructor) { create_instructor(:first_name => "Instructor", :last_name => "User", :github_id => '987') }
  let!(:student) {
    create_student(
      cohort,
      first_name: "Student",
      last_name: "User",
      github_id: '123',
      github_username: "Student12345"
    )
  }
  scenario "can view a students zpd responses " do
    student.update_attributes(auth_token: 'foo_token')
    VCR.use_cassette('challenges_and_student_challenges') do
      sign_in(instructor)

      visit user_path(student)
      within '.nav-stacked' do
        click_on "Student Dashboard (Instructor View)"
      end

      expect(page).to have_content "Javascript Challenges"
    end
  end
end