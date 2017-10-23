require 'rails_helper'

feature 'Class Projects' do

  let!(:cohort) {
    create_cohort
  }

  let!(:instructor) {
    create_instructor(
      first_name: "Instructor",
      last_name: "User",
      github_id: '987',
    )
  }

  let!(:student_1) {
    create_student(cohort)
  }

  let!(:student_2) {
    create_student(cohort)
  }

  scenario "instructors can create assessments, students can fill them in, instructors can score" do
    sign_in(instructor)
    within(".navbar") do
      click_on "Assessments"
    end
    click_on "New Assessment"
    fill_in "Name", with: "CSS Fundamentals"
    fill_in "Markdown", with: [
      '1. What is a float?',
      '',
      '  <textarea id="foo-1"></textarea>',
      '',
      '1. What color is #efefef',
      '',
      '  <input type="text" id="foo-1" data-answer="gray">',
    ].join("\n")
    fill_in 'Time Allowed', with: 30
    click_on 'Create Assessment'

    expect(page).to have_content('Found duplicate id foo-1')

    fill_in "Markdown", with: [
      '1. What is a float?',
      '',
      "\t<textarea id=\"foo-1\"></textarea>",
      '',
      '1. What color is #efefef',
      '',
      "\t<textarea id=\"foo-2\" data-answer=\"gray\"></textarea>",
    ].join("\n")
    click_on 'Create Assessment'

    expect(page).to have_content('Assessment was created')
    expect(page).to have_selector('.question-text', text: 'What is a float?')
    expect(page).to have_selector('.question-text', text: 'What color is')

    click_on "Create Given assessment"

    expect(page).to have_content("Assessment was assigned to #{cohort.name}")

    click_on "Sign Out"
    sign_in(student_1)

    click_on "Assessments"
    click_on "CSS Fundamentals"
    fill_in "foo-1", with: "no idea"
    fill_in "foo-2", with: "black"
    click_on "Save"

    expect(page).to have_content("Assessment was saved")
    expect(page).to have_no_content("You have 1 assessment in progress")

    visit cohort_daily_plans_path(cohort)
    expect(page).to have_content("You have 1 assessment in progress")

    click_on "Assessments"
    click_on "CSS Fundamentals"
    click_on "Save"
    click_on "Submit", match: :first
    expect(page).to have_content("CSS Fundamentals (finished)")
    expect(page).to have_content("Assessment was submitted")

    click_on "Sign Out"
    sign_in(instructor)

    visit cohort_path(cohort)
    within('[role=main]') do
      click_on "Assessments"
    end

    click_on "CSS Fundamentals"
    click_on "Score"
    choose 'Correct'
    fill_in "answers[#{student_1.id}][notes]", with: "Good job!"
    click_on "Score!"

    expect(page).to have_content('foo-1 scores were recorded')
  end
end
