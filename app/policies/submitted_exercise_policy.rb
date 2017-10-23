class SubmittedExercisePolicy < ApplicationPolicy
  def generate_dot_file?
    user.instructor? || user.submitted_exercises == record
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
