require 'rails_helper'

feature 'PairGenerator' do
  let(:cohort) { create_cohort(name: 'g2') }
  let!(:student1) {
    create_student(
      cohort,
      first_name: "First",
      last_name: "Student",
      github_id: '123',
    )
  }
  let(:instructor) { create_instructor(first_name: "Github", last_name: "User", github_id: '456') }

  scenario "instructors can generate random pair list that doesn't include instructors" do
    sign_in(instructor)

    click_on 'Cohorts'
    click_on 'g2', match: :first
    click_on 'Pairs'

    within "tr", text: student1.full_name do
      expect(page).to have_content "Instructor"
    end
  end
end
