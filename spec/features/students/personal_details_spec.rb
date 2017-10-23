require "rails_helper"

feature "Student adding personal details" do
  scenario "a student can add personal details to their account" do
    @cohort = create_cohort(name: "Cohort Name")
    create_student(
      @cohort,
      first_name: "Jeff",
      last_name: "Taggart",
      email: "user@example.com",
    )
    mock_omniauth

    visit root_path
    click_on I18n.t("nav.sign_in")
    click_on "Personal Info"

    fill_in "Address 1", with: "123 Street"
    fill_in "Address 2", with: "#10"
    fill_in "City", with: "Denver"
    select "Colorado", from: "State"
    fill_in "Zip Code", with: "80204"

    fill_in "Phone", with: "303-910-5555"
    fill_in "Twitter", with: "jetaggart"
    fill_in "Linkedin", with: "http://linkedin.com/jetaggart"
    fill_in "Blog", with: "someblog.com"
    select "Women's-M", from: "Shirt Size"

    click_on "Update Profile"
    expect(page).to have_content("Profile updated successfully")

    click_on "Personal Info"

    expect(find_field("Address 1").value).to eq("123 Street")
    expect(find_field("Address 2").value).to eq("#10")
    expect(find_field("City").value).to eq("Denver")
    expect(find_field("State").value).to eq("CO")
    expect(find_field("Zip Code").value).to eq("80204")
    expect(find_field("Phone").value).to eq("303-910-5555")
    expect(find_field("Twitter").value).to eq("jetaggart")
    expect(find_field("Linkedin").value).to eq("http://linkedin.com/jetaggart")
    expect(find_field("Blog").value).to eq("someblog.com")
    expect(find_field("Shirt Size").value).to eq("Women's-M")
  end

  scenario "an instructor can see student information" do
    @cohort = create_cohort(name: "Cohort Name")

    create_student(
      @cohort,
      first_name: "Jeff",
      last_name: "Taggart",
      address_1: "123 Street",
      address_2: "#10",
      city: "Denver",
      state: "CO",
      zip_code: "80204",
      email: "user@example.com",
      phone: "303-111-1111",
      twitter: "twitter_handle",
      linkedin: "http://linkedin.com/profile",
      blog: "blog.com",
      shirt_size: "Men's-L",
    )

    create_instructor(
      first_name: "Instructor",
      last_name: "User",
      email: "admin@example.com",
    )

    mock_omniauth(info_overrides: {email: "admin@example.com"})

    visit "/"
    click_on I18n.t("nav.sign_in")
    visit cohort_path(@cohort)

    click_on "Jeff Taggart"

    expect(page).to have_content("Jeff Taggart")

    expect(page).to have_content("123 Street")
    expect(page).to have_content("#10")
    expect(page).to have_content("Denver")
    expect(page).to have_content("CO")
    expect(page).to have_content("80204")

    expect(page).to have_content("user@example.com")
    expect(page).to have_content("303-111-1111")
    expect(page).to have_content("twitter_handle")
    expect(page).to have_content("http://linkedin.com/profile")
    expect(page).to have_content("blog.com")
    expect(page).to have_content("Men's-L")
  end
end
