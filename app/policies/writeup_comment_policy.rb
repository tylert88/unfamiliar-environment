class WriteupCommentPolicy < ApplicationPolicy

  def create?
    user.instructor? || record.writeup.user == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
