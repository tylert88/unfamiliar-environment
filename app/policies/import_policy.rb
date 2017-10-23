class ImportPolicy < Struct.new(:user, :import)

  def any?;   user.instructor?; end

end
