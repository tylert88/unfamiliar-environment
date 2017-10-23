class UserExpectationPolicy < ApplicationPolicy

  def index?
    user.instructor? || record == user
  end

  def list?
    user.instructor?
  end

  def show?
    user.instructor? || record.user == user
  end

  def new?
    user.instructor?
  end

  def create?
    user.instructor?
  end

  def edit?
    user.instructor?
  end

  def update?
    user.instructor?
  end

  def destroy?
    user.instructor?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
