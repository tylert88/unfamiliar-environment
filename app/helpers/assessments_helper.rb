module AssessmentsHelper

  def given_assessment_json(given_assessment)
    result = [['Student', 'Value']]
    result += given_assessment.taken_assessments.scored.map do |taken_assessment|
      [
        current_name_or_classmate(taken_assessment.user),
        taken_assessment.score
      ]
    end
    result.to_json
  end


end
