class MentorDashboardPolicy < ApplicationPolicy

  def show?;    user.instructor? || user == record; end

  class Scope < Scope
    def resolve
      if user.instructor?
        Mentorship.all
      else
        Mentorship.current
      end
    end
  end

end
