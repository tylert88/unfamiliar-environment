class CohortPolicy < ApplicationPolicy

  def index?
    user.instructor?
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

  def show?
    user.instructor?
  end

  def send_one_on_ones?
    user.instructor?
  end

  def one_on_ones?
    user.instructor?
  end

  def acceptance?
    user.instructor?
  end

  def refresh_acceptance?
    user.instructor?
  end

  def mentorships?
    user.instructor?
  end

  def social?
    user.instructor?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
