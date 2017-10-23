require 'rails_helper'

feature 'Expectations' do

  scenario "User creates courses and expectations" do
    sign_in(create_instructor)

    visit courses_path
    click_on "New Course"
    fill_in "Name", with: "Fullstack"
    click_on "Create Course"

    click_on "New Expectation"
    fill_in "Name", with: "Do Rails things"
    fill_in "Description", with: "Lots and lots"
    click_on "Create Expectation"

    expect(page).to have_content("Do Rails things")
    expect(page).to have_content("Lots and lots")
    expect(page).to have_content("Fullstack")

    click_on "Clone"
    expect(page).to have_content("Course was cloned successfully")
  end

end
