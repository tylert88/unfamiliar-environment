class EmploymentProfilePolicy < ApplicationPolicy

  def show?;    user.instructor? || record.user == user; end
  def edit?;    user.instructor? || record.user == user; end
  def create?;  user.instructor? || record.user == user; end
  def update?;  user.instructor? || record.user == user; end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
