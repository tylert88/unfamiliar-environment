require "rails_helper"

describe Cohort do

  it 'requires a name' do
    cohort = new_cohort(name: "")
    expect(cohort).to_not be_valid

    cohort.name = "March Cohort"
    expect(cohort).to be_valid
  end

  describe "#order_added_exercises" do
    it "returns exercises in the order they were added" do
      cohort = create_cohort

      exercise_2 = create_exercise
      CohortExercise.create!(cohort: cohort, exercise: exercise_2, created_at: Time.now - 1.day)

      exercise_1 = create_exercise
      CohortExercise.create!(cohort: cohort, exercise: exercise_1, created_at: Time.now - 2.days)

      exercise_3 = create_exercise
      CohortExercise.create!(cohort: cohort, exercise: exercise_3, created_at: Time.now)


      cohort.reload
      expect(cohort.order_added_exercises).to eq([exercise_1, exercise_2, exercise_3])
    end
  end

end
