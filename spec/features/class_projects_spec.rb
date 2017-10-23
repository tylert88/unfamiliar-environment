require 'rails_helper'

feature 'Class Projects' do

  let!(:instructor) {
    create_instructor(
      first_name: "Instructor",
      last_name: "User",
      github_id: '987',
    )
  }

  scenario "instructors can create class projects and epics" do
    sign_in(instructor)
    click_on "Class Projects"
    click_on "New Class Project"
    fill_in "Name", with: "gCamp"
    fill_in "Slug", with: "gcamp"
    click_on "Create Class project"
    click_on "gCamp"
    click_on "New Epic"
    fill_in "Name", with: "Permissions"
    click_on "Create Epic"
    expect(page).to have_content("Epic was added")

    fill_in "Title", with: "Users can do fun things"
    click_on "Create Story"
    expect(page).to have_content("Story was added")
    expect(page).to have_content("Users can do fun things")
  end

end
