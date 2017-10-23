module ObjectFactories

  def create_pairing(overrides = {})
    defaults = {
      feedback: 'great job!',
      paired_on: Date.current,
    }
    Pairing.create!(defaults.merge(overrides))
  end

  def create_staffing(overrides = {})
    new_staffing(overrides).tap do |u|
      u.save!
    end
  end

  def new_staffing(overrides = {})
    defaults = {
      :status => :active
    }
    Staffing.new(defaults.merge(overrides))
  end

  def create_pair_rotation(overrides = {})
    new_pair_rotation(overrides).tap(&:save!)
  end

  def new_pair_rotation(overrides = {})
    defaults = { cohort: new_cohort, pairs: [], position: counter }
    PairRotation.new(defaults.merge(overrides))
  end

  def create_student(cohort = new_cohort, overrides = {})
    create_user(overrides).tap do |user|
      create_enrollment(user: user, cohort: cohort)
    end
  end

  def new_epic(overrides = {})
    defaults = {
      class_project: new_class_project,
      name: Faker::Company.bs
    }
    Epic.new(defaults.merge(overrides))
  end

  def create_epic(overrides = {})
    new_epic(overrides).tap(&:save!)
  end

  def new_daily_plan(overrides = {})
    defaults = {
      cohort: new_cohort,
      description: Faker::Company.bs,
      date: Date.current
    }
    DailyPlan.new(defaults.merge(overrides))
  end

  def create_daily_plan(overrides = {})
    new_daily_plan(overrides).tap(&:save!)
  end

  def new_class_project(overrides = {})
    index = counter
    defaults = {
      name: "Class Project #{counter}",
      slug: "class-project-#{counter}",
    }
    ClassProject.new(defaults.merge(overrides))
  end

  def create_class_project(overrides = {})
    new_class_project(overrides).tap(&:save!)
  end

  def create_instructor(overrides = {})
    new_instructor(overrides).tap(&:save!)
  end

  def new_instructor(overrides = {})
    new_user(overrides).tap do |u|
      u.role = :instructor
    end
  end

  def create_user(overrides = {})
    new_user(overrides).tap do |u|
      u.save!
    end
  end

  def new_user(overrides = {})
    defaults = {
      email: "user#{rand}@example.com",
      first_name: 'John',
      last_name: 'Smith',
      github_id: SecureRandom.uuid
    }
    User.new(defaults.merge(overrides))
  end

  def create_enrollment(overrides = {})
    new_enrollment(overrides).tap(&:save!)
  end

  def new_enrollment(overrides = {})
    defaults = {
      role: :student,
      status: :enrolled,
      cohort: new_cohort,
      user: new_user,
    }
    Enrollment.new(defaults.merge(overrides))
  end

  def new_campus(overrides = {})
    defaults = {
      name: Faker::Company.name,
      directions: "<p>Some directions</p>",
      google_maps_location: 'https://google.com',
    }
    Campus.new(defaults.merge(overrides))
  end

  def create_campus(overrides = {})
    new_campus(overrides).tap(&:save!)
  end

  def new_course(overrides = {})
    defaults = {
      name: "Course ##{counter}",
    }
    Course.new(defaults.merge(overrides))
  end

  def create_course(overrides = {})
    new_course(overrides).tap(&:save!)
  end

  def create_cohort(overrides = {})
    new_cohort(overrides).tap(&:save)
  end

  def new_cohort(overrides = {})
    defaults = {
      name: "galvanize-#{rand(1000)}",
      start_date: 2.months.ago,
      course: new_course,
      end_date: 2.months.from_now,
      campus: new_campus,
    }
    Cohort.new(defaults.merge(overrides))
  end

  def create_exercise(overrides = {})
    new_exercise(overrides).tap do |a|
      a.save!
    end
  end

  def new_exercise(overrides = {})
    defaults = {
      curriculum: new_curriculum,
      name: 'Arrays and stuff',
      github_repo: 'http://example.com',
    }

    Exercise.new(defaults.merge(overrides))
  end

  def new_submission(overrides = {})
    defaults = {
      :github_repo_name => 'repo'
    }

    Submission.new(defaults.merge(overrides))
  end

  def create_submission(overrides = {})
    new_submission(overrides).tap do |s|
      s.save!
    end
  end

  def new_employment(overrides = {})
    defaults = {
      user_id: new_user,
      company_name: "Galvanize"
    }
    Employment.new(defaults.merge(overrides))
  end

  def create_employment(overrides = {})
    new_employment(overrides).tap do |e|
      e.save!
    end
  end

  def new_employment_profile(overrides = {})
    defaults = {
      user_id: new_user,
      status: "visible",
    }
    EmploymentProfile.new(defaults.merge(overrides))
  end

  def create_employment_profile(overrides = {})
    new_employment_profile(overrides).tap do |e|
      e.save!
    end
  end

  def new_curriculum(overrides = {})
    defaults = {
      name: "#{counter}",
      description: "get learnt",
      version: "#{counter}-FS-BD"
    }
    Curriculum.new(defaults.merge(overrides))
  end

  def create_curriculum(overrides = {})
    new_curriculum(overrides).tap(&:save!)
  end

  def create_zpd_response(overrides = {})
    defaults = {
      user_id: create_user.id,
      response: 0,
      date: Date.current
    }

    ZpdResponse.create!(defaults.merge(overrides))
  end

  def create_challenge(overrides = {})
    defaults = {
      cohort_id: create_cohort.id,
      directory_name: "foo-dir",
      github_url: "http://github.com/gschool"
    }

    Challenge.create!(defaults.merge(overrides))
  end

  def create_student_challenge(overrides = {})
    defaults = {
      challenge_id: create_challenge.id,
      file: "foo.rb",
      passed: 0,
      failed: 2,
      user_id: create_user.id,
      submission_count: 1,
      complete: false
    }

    StudentChallenge.create!(defaults.merge(overrides))
  end

  def create_learning_experience(overrides = {})
    defaults = {
      curriculum: new_curriculum,
      name: "jQuery"
    }

    LearningExperience.create!(defaults.merge(overrides))
  end

  def create_experience_objective(overrides = {})
    defaults = {
      learning_experience_id: create_learning_experience.id,
      objective_id: create_objective.id
    }

    ExperienceObjective.create!(defaults.merge(overrides))
  end

  def create_action_plan_entry(overrides = {})
    defaults = {
      cohort: new_cohort,
      description: "# Some header",
      status: :unstarted
    }

    ActionPlanEntry.create!(defaults.merge(overrides))
  end

  def create_assignment(overrides = {})
    cohort = create_cohort
    defaults = {
      cohort_id: cohort.id,
      name: "JS Assignment",
      url: "http://github.com",
      due_date: Date.today
    }
    assignment = Assignment.create!(defaults.merge(overrides))
    AssignmentSubmission.seed_for_assignment(assignment, Cohort.find_by(id: overrides[:cohort_id]) || cohort)
    assignment
  end

  def create_standard(overrides = {})
    defaults = {
      name: "Full Stack #{counter}",
      curriculum_id: create_curriculum.id,
      tags: ["Precourse"]
    }

    Standard.create!(defaults.merge(overrides))
  end

  def create_performance(overrides = {})
    defaults = {
      score: 0,
      updator: new_user
    }

    Performance.create!(defaults.merge(overrides))
  end

  def create_objective(overrides = {})
    defaults = {
      standard_id: create_standard.id,
      name: "Explain MVC #{counter}"
    }

    Objective.create!(defaults.merge(overrides))
  end

  def new_assessment(overrides = {})
    defaults = {
      name: "Assessment #{counter}",
      time_allowed_in_minutes: 1,
      markdown: [
        '1. What is a float?',
        '',
        "\t<textarea id=\"foo-1\"></textarea>",
        '',
        '1. What color is #efefef',
        '',
        "\t<textarea id=\"foo-2\" data-answer=\"gray\"></textarea>",
      ].join("\n")
    }

    Assessment.new(defaults.merge(overrides))
  end

  def create_assessment(overrides = {})
    new_assessment(overrides).tap(&:save!)
  end

  def new_given_assessment(overrides = {})
    defaults = {
      given_on: Time.zone.today,
      cohort: new_cohort,
      assessment: new_assessment,
      markdown: [
        '1. What is a float?',
        '',
        "\t<textarea id=\"foo-1\"></textarea>",
        '',
        '1. What color is #efefef',
        '',
        "\t<textarea id=\"foo-2\" data-answer=\"gray\"></textarea>",
      ].join("\n"),
      name: "Given Assessment #{counter}",
      time_allowed_in_minutes: 1,
    }

    GivenAssessment.new(defaults.merge(overrides))
  end

  def create_given_assessment(overrides = {})
    new_given_assessment(overrides).tap(&:save)
  end

  def create_taken_assessment(overrides = {})
    defaults = {
      user: new_user,
      given_assessment: new_given_assessment,
      status: :in_progress,
    }

    TakenAssessment.create!(defaults.merge(overrides))
  end

  def create_answer(overrides = {})
    defaults = {
    }

    Answer.create!(defaults.merge(overrides))
  end

  private def counter
    @counter ||= 0
    @counter += 1
    @counter
  end
end
