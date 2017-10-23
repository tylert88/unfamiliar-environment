class Course < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  has_many :expectations

  before_destroy :ensure_no_requirements

  private def ensure_no_requirements
    return false if expectations.present?
  end

end
