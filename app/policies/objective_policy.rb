class ObjectivePolicy < ApplicationPolicy

  def index?; true end
  def reorder?; user.instructor? end
  def update_order?; user.instructor? end
  def show?
    user.instructor? || (user.current_cohort && user.current_cohort.curriculum_id == record.standard.curriculum_id)
  end
  def new?;     user.instructor?; end
  def create?;  user.instructor?; end
  def edit?;    user.instructor?; end
  def update?;  user.instructor?; end
  def delete?; user.instructor?; end
  def destroy?; user.instructor?; end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
