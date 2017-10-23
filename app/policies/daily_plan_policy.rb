class DailyPlanPolicy < ApplicationPolicy

  def index?
    true
  end

  def search?
    true
  end

  def create?
    user.instructor?
  end

  def show?
    user.instructor? ||
      user.cohorts.include?(record.cohort) ||
      Mentorship.mentee_cohorts_for(user).include?(record.cohort)
  end

  def new?
    user.instructor?
  end

  def update?
    user.instructor?
  end

  def edit?
    user.instructor?
  end

  def destroy?
    user.instructor?
  end

  class Scope < Scope
    def resolve
      if user.instructor?
        scope
      elsif user.current_cohort
        scope.where(cohort_id: user.enrollments.enrolled.pluck(:cohort_id))
      else
        cohorts = Mentorship.mentee_cohorts_for(user)
        scope.where(cohort_id: cohorts)
      end
    end
  end
end
