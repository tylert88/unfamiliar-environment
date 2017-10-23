class Cohort < ActiveRecord::Base

  belongs_to :enrollments
  belongs_to :campus, class_name: "Campus"
  belongs_to :course
  has_many :cohort_exercises, dependent: :destroy
  has_many :exercises, :through => :cohort_exercises
  has_many :staffings, dependent: :destroy
  has_many :writeup_topics, dependent: :destroy
  has_many :instructors, :through => :staffings, :source => :user
  has_many :given_assessments

  mount_uploader :hero, HeroUploader

  validates :name, :start_date, :end_date, :presence => true
  validates :greenhouse_job_id, uniqueness: {allow_blank: true}
  validates :campus, presence: true
  validates :course, presence: true

  def order_added_exercises
    cohort_exercises.includes(:exercise).order(:created_at).map(&:exercise)
  end

  def self.current
    where('? between start_date and end_date', Date.current)
  end

  def self.upcoming
    where('start_date > ?', Date.current)
  end

  def self.announced
    where(announced: true)
  end
end
