class StudentDashboardPolicy < ApplicationPolicy
  def show?
    user.instructor?
  end
end