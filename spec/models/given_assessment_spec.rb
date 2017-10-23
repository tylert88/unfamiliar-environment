require 'rails_helper'

describe GivenAssessment do

  describe "#update_statuses" do

    it "updates the status if they are all answered" do
      cohort = create_cohort
      student1 = create_student(cohort)
      student2 = create_student(cohort)

      assessment = create_assessment
      given_assessment = create_given_assessment(assessment: create_assessment, cohort: cohort)
      taken_assessment1 = create_taken_assessment(given_assessment: given_assessment, user: student1)
      taken_assessment2 = create_taken_assessment(given_assessment: given_assessment, user: student2)

      create_answer(taken_assessment: taken_assessment1, question_id: 0, score: 1)
      create_answer(taken_assessment: taken_assessment1, question_id: 1, score: 1)

      given_assessment.update_statuses

      expect(taken_assessment1.reload.status).to eq("scored")
      expect(taken_assessment2.reload.status).to eq("in_progress")
    end

  end

end
