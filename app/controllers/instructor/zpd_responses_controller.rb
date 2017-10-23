class Instructor::ZpdResponsesController < ApplicationController
  def index
    zpd_responses = ZpdResponse.for_cohort(@cohort)
    @zpd_responses = ZpdResponse.build_zpd_repsonses(zpd_responses).to_json
  end
end
