FileUtils.rm_rf(Rails.root.join("public", "uploads"))

if File.exists?(Rails.root.join(".seedrc"))
  puts "Reading config values from .seedrc..."
  config = YAML.load_file(Rails.root.join(".seedrc"))
  instructor_email = config[:instructor][:github_email]
  student_email = config[:student][:github_email]
  generate_images = config[:generate_images]
else
  print "Email for instructor user (needs to be valid on GitHub): "
  instructor_email = $stdin.gets.chomp

  print "Email for student user (needs to be valid on GitHub): "
  student_email = $stdin.gets.chomp

  print "Generate thumbnails for students (takes a loooong time)?  y/n: "
  generate_images = ($stdin.gets.chomp == "y")

  config = {
    generate_images: generate_images,
    student: {
      github_email: student_email,
    },
    instructor: {
      github_email: instructor_email,
    },
  }

  puts "Writing config values to .seedrc..."
  File.open(Rails.root.join(".seedrc"), "w") do |f|
    f.puts config.to_yaml
  end
end

course = Course.create!(name: "Fullstack")

boulder = Campus.create!(
  name: "Boulder",
  directions: "Enter the building...",
  google_maps_location: "https://www.google.com/maps/embed?pb=!1m5!3m3!1m2!1s0x876bec26e4137699%3A0xf9d8bd928167d4d5!2s1035+Pearl+St%2C+Boulder%2C+CO+80302!5e0!3m2!1sen!2sus!4v1387232536923",
)
denver = Campus.create!(
  name: "Denver Golden Triangle",
  directions: "Enter the building...",
  google_maps_location: "https://www.google.com/maps/embed?pb=!1m5!3m3!1m2!1s0x876bec26e4137699%3A0xf9d8bd928167d4d5!2s1035+Pearl+St%2C+Boulder%2C+CO+80302!5e0!3m2!1sen!2sus!4v1387232536923",
)

puts "Creating cohorts..."
cohort1 = Cohort.new(
  name: "Cohort 1",
  start_date: 4.months.ago,
  end_date: 2.months.from_now,
  course: course,
  showcase: true,
  campus: boulder,
)
if generate_images
  cohort1.hero = File.open(Rails.root.join("db", "seeds", "hero.jpg"))
end
cohort1.save!

cohort2 = Cohort.new(
  name: "Cohort 2",
  start_date: 3.months.ago,
  end_date: 3.months.from_now,
  course: course,
  campus: denver,
)
if generate_images
  cohort2.hero = File.open(Rails.root.join("db", "seeds", "hero.jpg"))
end
cohort2.save!

puts "Creating instructor..."
instructor = User.create!(
  first_name: "Instructor",
  last_name: "User",
  email: instructor_email,
  role: :instructor
)

Staffing.create!(
  user: instructor,
  cohort: cohort1,
  status: :active,
)

images = %w(female-01.png female-02.png female-03.png male-01.png male-02.png male-03.png)

if student_email.present?
  student = User.new(
    first_name: "Student",
    last_name: "User",
    email: student_email,
    role: :user,
  )
  if generate_images
    puts "Creating student (takes a while to process the image)..."
    student.avatar = File.open(Rails.root.join("db", "seeds", images.sample))
  else
    puts "Creating student..."
  end
  student.save!
  Enrollment.create!(
    user: student,
    cohort: cohort1,
    status: :enrolled,
    role: :student
  )
end

[cohort1, cohort2].each do |cohort|
  27.times do
    user = User.new(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      github_username: Faker::Internet.user_name,
      role: :user,
    )
    if generate_images
      puts "Creating student (takes a while to process the image)..."
      user.avatar = File.open(Rails.root.join("db", "seeds", images.sample))
    else
      puts "Creating student..."
    end
    user.save!
    Enrollment.create!(
      user: user,
      cohort: cohort,
      status: :enrolled,
      role: :student
    )
  end
end
