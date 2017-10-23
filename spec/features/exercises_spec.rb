require "rails_helper"

feature "Exercises" do

  let!(:cohort) { create_cohort(:name => "Boulder Galvanize") }
  let!(:instructor) { create_instructor(:first_name => "Instructor", :last_name => "User", :github_id => "987") }
  let!(:curriculum) { create_curriculum(:name => "Full Stack") }
  let!(:student) {
    create_student(
      cohort,
      first_name: "Student",
      last_name: "User",
      github_id: "123",
      github_username: "Student12345"
    )
  }

  before do
    sign_in(instructor)
  end

  scenario "instructor is able to create and edit exercises" do
    click_on "Curriculums", match: :first
    click_on "Full Stack"
    click_on "Exercises", match: :first
    click_on "Create Exercise"

    fill_in "Name", :with => "Bunch of array"
    fill_in "GitHub Repo", :with => "repo"
    click_on "Add Exercise"

    expect(page).to have_content "Exercise successfully created"
    expect(page).to have_content("Bunch of array")

    expect(find_link("Bunch of array")['href']).to eq("https://github.com/gSchool/repo")

    within("table") do
      click_on('edit')
    end

    fill_in "Name", :with => "Bunch of Hashes"
    fill_in "GitHub Repo", :with => "https://example.com/hash_repo"
    click_on "Update Exercise"

    expect(page).to have_content "Exercise successfully created"
    expect(find_link("Bunch of Hashes")['href']).to eq("https://example.com/hash_repo")
  end

  scenario "instructor does not see exercises that have been assigned" do
    exercise_1 = create_exercise(:name => "Nested Hashes", github_repo: "nested_hashes")
    create_exercise(:name => "Harleigh", github_repo: "harleigh_is_amazing")

    CohortExercise.create!(
      cohort: cohort,
      exercise: exercise_1,
    )

    visit cohorts_path

    click_link cohort.name, match: :first
    within(".cohort-nav") do
      click_link "Exercises"
    end
    click_link "Assign Exercise"

    expect(page).to have_content("Harleigh")
    expect(page).to have_no_content("Nested Hashes")
  end

  scenario "instructor can assign and un-assign an exercise to a cohort" do
    create_exercise(:name => "Nested Hashes", github_repo: "nested_hashes")

    visit cohorts_path

    click_link cohort.name, match: :first
    within(".cohort-nav") do
      click_link "Exercises"
    end
    click_link "Assign Exercise"

    within("tr", :text => "Nested Hashes") do
      click_button "Add"
    end

    expect(page).to have_content "Exercise successfully added to cohort"
    expect(find_link("Nested Hashes")['href']).to eq("https://github.com/gSchool/nested_hashes")

    find(".remove-exercise-action", :visible => false).click

    expect(page).to have_content("Exercise removed.")
    expect(page).to have_no_content("Nested Hashes")
  end

  scenario "instructor can view who has and has not completed an exercise" do
    create_student(
      cohort,
      first_name: "Joe",
      last_name: "Mama",
    )

    exercise = create_exercise(:name => "Nested Hashes")
    cohort.update!(:exercises => [exercise])
    create_submission(
      :exercise => exercise,
      :user => student,
      :tracker_project_url => "http://www.pivotaltracker.com",
      :github_repo_name => "some_repo_name"
    )

    visit cohorts_path
    click_link cohort.name, match: :first
    within ".cohort-nav" do
      click_link "Exercises"
    end
    submission_count_link = find("td.submission_count a")
    expect(submission_count_link.text).to eq("1")
    submission_count_link.click

    within("section", :text => "Completed Submissions") do
      expect(all("a")[1]["href"]).to eq("https://github.com/Student12345/some_repo_name")
      expect(page).to have_link("Tracker Project")
    end

    within("section", :text => "Students Without Submissions") do
      expect(page).to have_content("Joe Mama")
    end
  end

  scenario "instructor only views student submissions from the given cohort" do
    student1 = create_student(
      cohort,
      first_name: "Joe",
      last_name: "Mama",
    )

    cohort2 = create_cohort
    student2 = create_student(
      cohort2,
      first_name: "Other",
      last_name: "Mama",
    )

    exercise = create_exercise(:name => "Nested Hashes")
    cohort.update!(:exercises => [exercise])
    cohort2.update!(:exercises => [exercise])

    create_submission(
      exercise: exercise,
      user: student1,
      tracker_project_url: "http://www.pivotaltracker.com",
      github_repo_name: "some_repo_name"
    )

    create_submission(
      exercise: exercise,
      user: student2,
      tracker_project_url: "http://www.pivotaltracker.com",
      github_repo_name: "some_repo_name"
    )

    visit cohorts_path
    click_link cohort.name, match: :first
    within(".cohort-nav") { click_link "Exercises" }
    submission_count_link = find("td.submission_count a")
    expect(submission_count_link.text).to eq("1")
    submission_count_link.click

    within("section", :text => "Completed Submissions") do
      expect(page).to have_content("Joe Mama")
      expect(page).to have_no_content("Other Mama")
    end
  end

  scenario "instructor can not delete an exercise that has submissions" do
    create_student(
      cohort,
      first_name: "Joe",
      last_name: "Mama",
    )

    exercise = create_exercise(:name => "Nested Hashes", github_repo: "nested_hashes")
    cohort.update!(:exercises => [exercise])
    create_submission(
      :exercise => exercise,
      :user => student,
      :tracker_project_url => "http://www.pivotaltracker.com",
      :github_repo_name => "some_repo_name"
    )

    visit cohorts_path
    click_link cohort.name, match: :first
    within(".cohort-nav") do
      click_link "Exercises"
    end
    submission_count_link = find("td.submission_count a")
    expect(submission_count_link.text).to eq("1")

    expect(find_link("Nested Hashes")['href']).to eq("https://github.com/gSchool/nested_hashes")

    expect(page).to_not have_css(".remove-exercise-action")
  end

  scenario "instructor can view what exercises a student has completed" do
    exercise_1 = create_exercise(:name => "Nested Hashes")
    exercise_2 = create_exercise(:name => "Arrays")

    cohort.update!(:exercises => [exercise_1, exercise_2])

    create_submission(
      :exercise => exercise_1,
      :user => student,
      :github_repo_name => "some_repo_name"
    )

    visit cohorts_path
    click_on cohort.name, match: :first
    click_on "Student User"

    within(".complete-exercises") do
      expect(page).to have_content("Nested Hashes")
    end

    within(".incomplete-exercises") do
      expect(page).to have_content("Arrays")
    end
  end

end
