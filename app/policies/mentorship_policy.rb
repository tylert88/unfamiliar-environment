class MentorshipPolicy < ApplicationPolicy

  def index?;   user.instructor? || user.user?; end
  def show?;    user.instructor? || record.user == user; end
  def new?;     user.instructor? || record.user == user; end
  def create?;  user.instructor? || record.user == user; end
  def edit?;    user.instructor? || record.user == user; end
  def update?;  user.instructor? || record.user == user; end
  def destroy?; user.instructor? || record.user == user; end

  class Scope < Scope
    def resolve
      if user.instructor?
        scope
      else
        scope.where(user_id: user)
      end
    end
  end
end
