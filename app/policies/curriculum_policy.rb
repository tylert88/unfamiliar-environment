class CurriculumPolicy < ApplicationPolicy

  def index?;   user.instructor?; end
  def show?
    user.instructor? || (user.current_cohort && user.current_cohort.curriculum_id == record.id)
  end
  def new_import?; user.instructor?; end
  def import?; user.instructor?; end
  def progress?; user.instructor?; end
  def new?;     user.instructor?; end
  def create?;  user.instructor?; end
  def edit?;    user.instructor?; end
  def update?;  user.instructor?; end
  def destroy?; user.instructor?; end
  def activity?; user.instructor?; end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
