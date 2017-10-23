class VideoPolicy < ApplicationPolicy

  def index?
    user.instructor?
  end

end
