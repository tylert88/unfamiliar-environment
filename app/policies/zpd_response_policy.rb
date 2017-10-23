class ZpdResponsePolicy < ApplicationPolicy

  def index?
    user.instructor?
  end

end
