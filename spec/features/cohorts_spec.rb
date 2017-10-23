require "rails_helper"

feature "Cohorts" do
  let!(:instructor) { create_instructor(:first_name => "Instructor", :last_name => "User", :github_id => '987') }

  scenario "an instructor creating and editing a cohort" do
    create_campus(name: "Boulder")
    create_course(name: "Fullstack")
    sign_in(instructor)

    click_on("Cohorts")
    click_on("New Cohort")

    fill_in("Name", :with => "Some new cohort")
    select("Boulder", :from => "Campus")
    select("Fullstack", :from => "Course")
    fill_in("Start date", :with => "2012-01-01")
    fill_in("End date", :with => "2012-02-01")
    attach_file "Hero", Rails.root.join("spec", "fixtures", "avatar.jpg")

    check "Showcase"

    click_on("Save")

    expect(page).to have_content("Cohort created")

    click_on "Some new cohort"
    click_on "Edit"

    expect(find_field("Name").value).to eq("Some new cohort")
    expect(find_field("Start date").value).to eq("2012-01-01")
    expect(find_field("End date").value).to eq("2012-02-01")
    expect(page).to have_checked_field("Showcase")

    fill_in("Name", :with => "Another new name")

    click_on("Save")

    expect(page).to have_content("Cohort saved")
    expect(page).to have_content("Another new name")
  end

  context "with an already existing cohort" do
    let!(:cohort) { create_cohort(:name => 'Boulder Galvanize') }
    let!(:student) {
      create_student(
        cohort,
        first_name: "Student",
        last_name: "User",
        github_id: '123',
        github_username: "Student12345"
      )
    }

    scenario "instructor can add student to cohort" do
      sign_in(instructor)

      visit cohorts_path

      click_on 'Boulder Galvanize', match: :first
      click_on 'Add Student'

      fill_in 'First name', :with => 'John'
      fill_in 'Last name', :with => 'Johnson'
      fill_in 'Email', :with => 'john@johnny.com'
      click_on 'Create User'

      expect(page).to have_content('User created successfully')
      expect(page).to have_content('Boulder Galvanize')
      expect(page).to have_content('John Johnson')
      expect(page).to have_content('john@johnny.com')
    end

    scenario "it shows errors on the add student form" do
      sign_in(instructor)

      visit cohorts_path

      click_on 'Boulder Galvanize', match: :first
      click_on 'Add Student'
      click_on 'Create User'

      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
    end

    scenario "instructors can see a one-on-one schedule" do
      instructor = create_instructor(:first_name => "Teacher", :last_name => "User", :github_id => '1010')
      create_student(
        cohort,
        first_name: "Student",
        last_name: "User",
        github_id: '1111',
        github_username: "Student12345"
      )
      create_staffing(cohort: cohort, user: instructor)
      sign_in(instructor)

      visit cohorts_path
      click_on cohort.name, match: :first
      click_on '1-on-1 Schedule'

      expect(page).to have_content("Student User")
      expect(page).to have_content("Teacher User")
      expect(page).to have_content("1:00pm")
    end

    scenario "instructors can see a table of acceptance links for gCamp" do
      instructor = create_instructor(:first_name => "Teacher", :last_name => "User", :github_id => '1010')
      user = create_student(
        cohort,
        first_name: "Student",
        last_name: "User",
        github_id: '1111',
        github_username: "Student12345"
      )
      create_staffing(cohort: cohort, user: instructor)
      class_project = create_class_project(name: 'gCamp')
      sign_in(instructor)
      epic = create_epic(class_project: class_project)
      CohortEpic.create!(
        cohort: cohort,
        epic: epic
      )

      StudentProject.create!(
        user: user,
        name: 'gCamp',
      )

      visit cohort_path(cohort)
      click_on 'gCamp Acceptance'

      expect(page).to have_content("Student User")
    end

  end
end
