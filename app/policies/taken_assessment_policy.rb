class TakenAssessmentPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    user.instructor? || record.user == user
  end

  def new?
    user.instructor? || record.user == user
  end

  def create?
    user.instructor? || record.user == user
  end

  def edit?
    record.in_progress? && (user.instructor? || record.user == user)
  end

  def update?
    record.in_progress? && (user.instructor? || record.user == user)
  end

  def submit?
    record.in_progress? && (user.instructor? || record.user == user)
  end

  def track?
    record.in_progress? && (user.instructor? || record.user == user)
  end

  def destroy?
    user.instructor?
  end

  class Scope < Scope
    def resolve
      if user.instructor?
        scope
      else
        scope.where(
          user_id: user.id
        )
      end
    end
  end
end
