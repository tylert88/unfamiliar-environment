class PerformancePolicy < ApplicationPolicy

  def index?
    true
  end
  # def show?;    user.instructor?; end
  # def new?;     user.instructor?; end
  def create?;  user.instructor?; end
  def data?;  user.instructor?; end
  def update_all?;  user.instructor?; end
  # def edit?;    user.instructor?; end
  def update?;  user.instructor?; end
  # def destroy?; user.instructor?; end

  class Scope < Scope
    def resolve
      if user.instructor?
        scope
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
