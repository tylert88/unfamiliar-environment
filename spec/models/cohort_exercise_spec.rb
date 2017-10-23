require "rails_helper"

describe CohortExercise do
  describe "#students_missing_submission" do
    it "returns only students" do
      cohort = create_cohort

      instructor = create_instructor
      student = create_student(cohort)

      cohort_exercise = CohortExercise.create!(exercise: create_exercise, cohort: cohort)

      expect(cohort_exercise.students_missing_submission).to match_array([student])
    end
  end
end
