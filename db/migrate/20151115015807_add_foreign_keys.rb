class AddForeignKeys < ActiveRecord::Migration
  def change
    execute "delete from action_plan_entries where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE action_plan_entries
        ADD CONSTRAINT fk_action_plan_entries_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from action_plan_entries where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE action_plan_entries
        ADD CONSTRAINT fk_action_plan_entries_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from action_plan_entries where learning_experience_id not in (select id from learning_experiences)"
    execute <<-SQL
      ALTER TABLE action_plan_entries
        ADD CONSTRAINT fk_action_plan_entries_learning_experience_id
        FOREIGN KEY (learning_experience_id) REFERENCES learning_experiences (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from answers where taken_assessment_id not in (select id from taken_assessments)"
    execute <<-SQL
      ALTER TABLE answers
        ADD CONSTRAINT fk_answers_taken_assessment_id
        FOREIGN KEY (taken_assessment_id) REFERENCES taken_assessments (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from assignment_submission_notes where assignment_submission_id not in (select id from assignment_submissions)"
    execute <<-SQL
      ALTER TABLE assignment_submission_notes
        ADD CONSTRAINT fk_assignment_submission_notes_assignment_submission_id
        FOREIGN KEY (assignment_submission_id) REFERENCES assignment_submissions (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from assignments where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE assignments
        ADD CONSTRAINT fk_assignments_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from challenges where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE challenges
        ADD CONSTRAINT fk_challenges_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from class_project_features where class_project_id not in (select id from class_projects)"
    execute <<-SQL
      ALTER TABLE class_project_features
        ADD CONSTRAINT fk_class_project_features_class_project_id
        FOREIGN KEY (class_project_id) REFERENCES class_projects (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from cohort_epics where epic_id not in (select id from epics)"
    execute <<-SQL
      ALTER TABLE cohort_epics
        ADD CONSTRAINT fk_cohort_epics_epic_id
        FOREIGN KEY (epic_id) REFERENCES epics (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from cohort_epics where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE cohort_epics
        ADD CONSTRAINT fk_cohort_epics_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from cohort_exercises where exercise_id not in (select id from exercises)"
    execute <<-SQL
      ALTER TABLE cohort_exercises
        ADD CONSTRAINT fk_cohort_exercises_exercise_id
        FOREIGN KEY (exercise_id) REFERENCES exercises (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from cohort_exercises where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE cohort_exercises
        ADD CONSTRAINT fk_cohort_exercises_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from cohorts where curriculum_id not in (select id from curriculums)"
    execute <<-SQL
      ALTER TABLE cohorts
        ADD CONSTRAINT fk_cohorts_curriculum_id
        FOREIGN KEY (curriculum_id) REFERENCES curriculums (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from cohorts where campus_id not in (select id from campuses)"
    execute <<-SQL
      ALTER TABLE cohorts
        ADD CONSTRAINT fk_cohorts_campus_id
        FOREIGN KEY (campus_id) REFERENCES campuses (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from cohorts where course_id not in (select id from courses)"
    execute <<-SQL
      ALTER TABLE cohorts
        ADD CONSTRAINT fk_cohorts_course_id
        FOREIGN KEY (course_id) REFERENCES courses (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from curriculum_notifications where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE curriculum_notifications
        ADD CONSTRAINT fk_curriculum_notifications_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from curriculum_notifications where curriculum_id not in (select id from curriculums)"
    execute <<-SQL
      ALTER TABLE curriculum_notifications
        ADD CONSTRAINT fk_curriculum_notifications_curriculum_id
        FOREIGN KEY (curriculum_id) REFERENCES curriculums (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from daily_plans where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE daily_plans
        ADD CONSTRAINT fk_daily_plans_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from deadlines where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE deadlines
        ADD CONSTRAINT fk_deadlines_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from employment_profiles where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE employment_profiles
        ADD CONSTRAINT fk_employment_profiles_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from employments where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE employments
        ADD CONSTRAINT fk_employments_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from enrollments where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE enrollments
        ADD CONSTRAINT fk_enrollments_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
    SQL

    execute "delete from enrollments where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE enrollments
        ADD CONSTRAINT fk_enrollments_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from epics where class_project_id not in (select id from class_projects)"
    execute <<-SQL
      ALTER TABLE epics
        ADD CONSTRAINT fk_epics_class_project_id
        FOREIGN KEY (class_project_id) REFERENCES class_projects (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from expectation_statuses where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE expectation_statuses
        ADD CONSTRAINT fk_expectation_statuses_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from expectation_statuses where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE expectation_statuses
        ADD CONSTRAINT fk_expectation_statuses_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from expectation_statuses where expectation_id not in (select id from expectations)"
    execute <<-SQL
      ALTER TABLE expectation_statuses
        ADD CONSTRAINT fk_expectation_statuses_expectation_id
        FOREIGN KEY (expectation_id) REFERENCES expectations (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from expectation_statuses where author_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE expectation_statuses
        ADD CONSTRAINT fk_expectation_statuses_author_id
        FOREIGN KEY (author_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from expectations where course_id not in (select id from courses)"
    execute <<-SQL
      ALTER TABLE expectations
        ADD CONSTRAINT fk_expectations_course_id
        FOREIGN KEY (course_id) REFERENCES courses (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from experience_objectives where learning_experience_id not in (select id from learning_experiences)"
    execute <<-SQL
      ALTER TABLE experience_objectives
        ADD CONSTRAINT fk_experience_objectives_learning_experience_id
        FOREIGN KEY (learning_experience_id) REFERENCES learning_experiences (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from experience_objectives where objective_id not in (select id from objectives)"
    execute <<-SQL
      ALTER TABLE experience_objectives
        ADD CONSTRAINT fk_experience_objectives_objective_id
        FOREIGN KEY (objective_id) REFERENCES objectives (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from given_assessments where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE given_assessments
        ADD CONSTRAINT fk_given_assessments_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from given_assessments where assessment_id not in (select id from assessments)"
    execute <<-SQL
      ALTER TABLE given_assessments
        ADD CONSTRAINT fk_given_assessments_assessment_id
        FOREIGN KEY (assessment_id) REFERENCES assessments (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from greenhouse_applications where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE greenhouse_applications
        ADD CONSTRAINT fk_greenhouse_applications_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from job_activities where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE job_activities
        ADD CONSTRAINT fk_job_activities_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from learning_experiences where curriculum_id not in (select id from curriculums)"
    execute <<-SQL
      ALTER TABLE learning_experiences
        ADD CONSTRAINT fk_learning_experiences_curriculum_id
        FOREIGN KEY (curriculum_id) REFERENCES curriculums (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from learning_experiences where subject_id not in (select id from subjects)"
    execute <<-SQL
      ALTER TABLE learning_experiences
        ADD CONSTRAINT fk_learning_experiences_subject_id
        FOREIGN KEY (subject_id) REFERENCES subjects (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from lessons where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE lessons
        ADD CONSTRAINT fk_lessons_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from lessons where lesson_plan_id not in (select id from lesson_plans)"
    execute <<-SQL
      ALTER TABLE lessons
        ADD CONSTRAINT fk_lessons_lesson_plan_id
        FOREIGN KEY (lesson_plan_id) REFERENCES lesson_plans (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from mentors where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE mentors
        ADD CONSTRAINT fk_mentors_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    # execute "delete from mentors where mentor_id not in (select id from users)"
    # execute <<-SQL
    #   ALTER TABLE mentors
    #     ADD CONSTRAINT fk_mentors_mentor_id
    #     FOREIGN KEY (mentor_id) REFERENCES users (id)
    #     ON DELETE CASCADE;
    # SQL

    execute "delete from mentorships where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE mentorships
        ADD CONSTRAINT fk_mentorships_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from mentorships where mentor_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE mentorships
        ADD CONSTRAINT fk_mentorships_mentor_id
        FOREIGN KEY (mentor_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from objectives where standard_id not in (select id from standards)"
    execute <<-SQL
      ALTER TABLE objectives
        ADD CONSTRAINT fk_objectives_standard_id
        FOREIGN KEY (standard_id) REFERENCES standards (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from pair_rotations where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE pair_rotations
        ADD CONSTRAINT fk_pair_rotations_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from pairings where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE pairings
        ADD CONSTRAINT fk_pairings_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from pairings where pair_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE pairings
        ADD CONSTRAINT fk_pairings_pair_id
        FOREIGN KEY (pair_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from performances where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE performances
        ADD CONSTRAINT fk_performances_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from performances where objective_id not in (select id from objectives)"
    execute <<-SQL
      ALTER TABLE performances
        ADD CONSTRAINT fk_performances_objective_id
        FOREIGN KEY (objective_id) REFERENCES objectives (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from performances where updator_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE performances
        ADD CONSTRAINT fk_performances_updator_id
        FOREIGN KEY (updator_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from planned_lessons where lesson_plan_id not in (select id from lesson_plans)"
    execute <<-SQL
      ALTER TABLE planned_lessons
        ADD CONSTRAINT fk_planned_lessons_lesson_plan_id
        FOREIGN KEY (lesson_plan_id) REFERENCES lesson_plans (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from snippets where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE snippets
        ADD CONSTRAINT fk_snippets_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from staffings where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE staffings
        ADD CONSTRAINT fk_staffings_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from staffings where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE staffings
        ADD CONSTRAINT fk_staffings_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from standards where curriculum_id not in (select id from curriculums)"
    execute <<-SQL
      ALTER TABLE standards
        ADD CONSTRAINT fk_standards_curriculum_id
        FOREIGN KEY (curriculum_id) REFERENCES curriculums (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from stories where epic_id not in (select id from epics)"
    execute <<-SQL
      ALTER TABLE stories
        ADD CONSTRAINT fk_stories_epic_id
        FOREIGN KEY (epic_id) REFERENCES epics (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_challenges where challenge_id not in (select id from challenges)"
    execute <<-SQL
      ALTER TABLE student_challenges
        ADD CONSTRAINT fk_student_challenges_challenge_id
        FOREIGN KEY (challenge_id) REFERENCES challenges (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_challenges where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE student_challenges
        ADD CONSTRAINT fk_student_challenges_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_deadlines where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE student_deadlines
        ADD CONSTRAINT fk_student_deadlines_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_deadlines where deadline_id not in (select id from deadlines)"
    execute <<-SQL
      ALTER TABLE student_deadlines
        ADD CONSTRAINT fk_student_deadlines_deadline_id
        FOREIGN KEY (deadline_id) REFERENCES deadlines (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_projects where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE student_projects
        ADD CONSTRAINT fk_student_projects_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_projects where class_project_id not in (select id from class_projects)"
    execute <<-SQL
      ALTER TABLE student_projects
        ADD CONSTRAINT fk_student_projects_class_project_id
        FOREIGN KEY (class_project_id) REFERENCES class_projects (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_snippets where snippet_id not in (select id from snippets)"
    execute <<-SQL
      ALTER TABLE student_snippets
        ADD CONSTRAINT fk_student_snippets_snippet_id
        FOREIGN KEY (snippet_id) REFERENCES snippets (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_snippets where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE student_snippets
        ADD CONSTRAINT fk_student_snippets_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_stories where class_project_id not in (select id from class_projects)"
    execute <<-SQL
      ALTER TABLE student_stories
        ADD CONSTRAINT fk_student_stories_class_project_id
        FOREIGN KEY (class_project_id) REFERENCES class_projects (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_stories where epic_id not in (select id from epics)"
    execute <<-SQL
      ALTER TABLE student_stories
        ADD CONSTRAINT fk_student_stories_epic_id
        FOREIGN KEY (epic_id) REFERENCES epics (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_stories where story_id not in (select id from stories)"
    execute <<-SQL
      ALTER TABLE student_stories
        ADD CONSTRAINT fk_student_stories_story_id
        FOREIGN KEY (story_id) REFERENCES stories (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from student_stories where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE student_stories
        ADD CONSTRAINT fk_student_stories_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from subjects where curriculum_id not in (select id from curriculums)"
    execute <<-SQL
      ALTER TABLE subjects
        ADD CONSTRAINT fk_subjects_curriculum_id
        FOREIGN KEY (curriculum_id) REFERENCES curriculums (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from submissions where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE submissions
        ADD CONSTRAINT fk_submissions_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from submissions where exercise_id not in (select id from exercises)"
    execute <<-SQL
      ALTER TABLE submissions
        ADD CONSTRAINT fk_submissions_exercise_id
        FOREIGN KEY (exercise_id) REFERENCES exercises (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from taggings where tag_id not in (select id from tags)"
    execute <<-SQL
      ALTER TABLE taggings
        ADD CONSTRAINT fk_taggings_tag_id
        FOREIGN KEY (tag_id) REFERENCES tags (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from taken_assessments where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE taken_assessments
        ADD CONSTRAINT fk_taken_assessments_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from taken_assessments where given_assessment_id not in (select id from given_assessments)"
    execute <<-SQL
      ALTER TABLE taken_assessments
        ADD CONSTRAINT fk_taken_assessments_given_assessment_id
        FOREIGN KEY (given_assessment_id) REFERENCES given_assessments (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from tracker_statuses where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE tracker_statuses
        ADD CONSTRAINT fk_tracker_statuses_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from tracker_statuses where class_project_id not in (select id from class_projects)"
    execute <<-SQL
      ALTER TABLE tracker_statuses
        ADD CONSTRAINT fk_tracker_statuses_class_project_id
        FOREIGN KEY (class_project_id) REFERENCES class_projects (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from user_learning_experiences where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE user_learning_experiences
        ADD CONSTRAINT fk_user_learning_experiences_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from user_learning_experiences where learning_experience_id not in (select id from learning_experiences)"
    execute <<-SQL
      ALTER TABLE user_learning_experiences
        ADD CONSTRAINT fk_user_learning_experiences_learning_experience_id
        FOREIGN KEY (learning_experience_id) REFERENCES learning_experiences (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from writeup_comments where writeup_id not in (select id from writeups)"
    execute <<-SQL
      ALTER TABLE writeup_comments
        ADD CONSTRAINT fk_writeup_comments_writeup_id
        FOREIGN KEY (writeup_id) REFERENCES writeups (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from writeup_comments where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE writeup_comments
        ADD CONSTRAINT fk_writeup_comments_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from writeup_topics where cohort_id not in (select id from cohorts)"
    execute <<-SQL
      ALTER TABLE writeup_topics
        ADD CONSTRAINT fk_writeup_topics_cohort_id
        FOREIGN KEY (cohort_id) REFERENCES cohorts (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from writeups where writeup_topic_id not in (select id from writeup_topics)"
    execute <<-SQL
      ALTER TABLE writeups
        ADD CONSTRAINT fk_writeups_writeup_topic_id
        FOREIGN KEY (writeup_topic_id) REFERENCES writeup_topics (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from writeups where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE writeups
        ADD CONSTRAINT fk_writeups_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    execute "delete from zpd_responses where user_id not in (select id from users)"
    execute <<-SQL
      ALTER TABLE zpd_responses
        ADD CONSTRAINT fk_zpd_responses_user_id
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;
    SQL

    # execute "delete from assignment_submissions where user_id not in (select id from users)"
    # execute <<-SQL
    #   ALTER TABLE assignment_submissions
    #     ADD CONSTRAINT fk_assignment_submissions_user_id
    #     FOREIGN KEY (user_id) REFERENCES users (id)
    #     ON DELETE CASCADE;
    # SQL

    execute "delete from assignment_submissions where assignment_id not in (select id from assignments)"
    execute <<-SQL
      ALTER TABLE assignment_submissions
        ADD CONSTRAINT fk_assignment_submissions_assignment_id
        FOREIGN KEY (assignment_id) REFERENCES assignments (id)
        ON DELETE CASCADE;
    SQL
  end
end
