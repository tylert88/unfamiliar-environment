class ExpectationStatusPolicy < ApplicationPolicy

  def index?;   user.instructor?; end
  def show?;    user.instructor?; end
  def new?;     user.instructor?; end
  def create?;  user.instructor?; end
  def destroy?; user.instructor?; end

  def edit?
    user.instructor? && record.draft?
  end

  def update?
    user.instructor? && record.draft?
  end

  def publish?
    user.instructor? && record.draft?
  end

  def mark_as_read?
    record.user == user && record.published?
  end

  class Scope < Scope
    def resolve
      if user.instructor?
        scope
      else
        scope.where(status: [
          ExpectationStatus.statuses['published'],
          ExpectationStatus.statuses['read']
        ])
      end
    end
  end
end
