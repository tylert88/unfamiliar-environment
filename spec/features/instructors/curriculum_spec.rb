require "rails_helper"

describe "managing a curriculum" do
    let!(:instructor) { create_instructor }

  it "allows instructors to create a curriculum" do
    sign_in(instructor)

    click_on "Curriculum"
    click_on "New Curriculum"
    fill_in "Name", with: "Full Stack Curriculum"
    fill_in "Version", with: "15-04-FS-BD"
    fill_in "Description", with: "All the curriculum for the Full Stack program"
    click_on "Create Curriculum"
    expect(page).to have_content("Curriculum was added successfully")

    click_on "New Standard"
    fill_in "Name", with: "Get to know your instructors"
    fill_in "Tags", with: "orientation,learn-to-learn"
    click_on "Create Standard"
    expect(page).to have_content("Standard Successfully Saved")
    expect(page).to have_selector('span', text: "learn-to-learn")
    expect(page).to have_selector('span', text: "orientation")

    click_on "New Objective"
    fill_in "Name", with: "Recite instructor names"
    click_on "Create Objective"

    expect(page).to have_content("Objective Successfully Saved")
    expect(page).to have_content("Recite instructor names")
  end

  it "allows instructors to mark students as having completed objectives (skills)" do
    cohort = create_cohort
    student = create_student(cohort)
    sign_in(instructor)

    visit cohort_path(cohort)
    click_on "Performance", match: :first
    expect(page).to have_content(student.full_name)
  end
end
