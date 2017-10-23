class PairRotationPolicy < ApplicationPolicy

  def index?;   user.instructor?; end
  def show?;    user.instructor?; end
  def new?;     user.instructor?; end
  def create?;  user.instructor?; end
  def edit?;    user.instructor?; end
  def update?;  user.instructor?; end
  def destroy?; user.instructor?; end
  def generate?; user.instructor?; end
  def assign?; user.instructor?; end
  def unassign?; user.instructor?; end
  def random?; user.instructor?; end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
