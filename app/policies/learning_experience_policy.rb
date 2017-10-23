class LearningExperiencePolicy < ApplicationPolicy

  def index?;         true; end
  def show?;          true; end
  def new?;           user.instructor?; end
  def create?;        user.instructor?; end
  def edit?;          user.instructor?; end
  def update?;        user.instructor?; end
  def destroy?;       user.instructor?; end
  def reorder?;       user.instructor?; end
  def update_order?;  user.instructor?; end
  def assign?;        user.instructor?; end
  def create_assignment?; user.instructor?; end
end
