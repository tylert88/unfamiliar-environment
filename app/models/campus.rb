class Campus < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :google_maps_location, presence: true
  validates :directions, presence: true

  has_many :cohorts

  before_destroy :ensure_no_cohorts

  private def ensure_no_cohorts
    return false if cohorts.present?
  end

end
