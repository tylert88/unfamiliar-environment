class InstructorRequiredController < ApplicationController
  before_action do
    raise Pundit::NotAuthorizedError unless current_user.instructor?
  end
end
