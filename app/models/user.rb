class User < ActiveRecord::Base
  enum role: [ :user, :instructor, :galvanizer ]
  enum status: [ :active, :inactive ]

  attr_accessor :password_was_set, :password_confirmation_was_set

  has_secure_password(validations: false)
  validates_confirmation_of :password, if: ->{ password_was_set && password_confirmation_was_set }
  validate do |record|
    if password_was_set && password_confirmation_was_set && password.blank?
      record.errors.add(:password, :blank)
    end
  end

  validates :greenhouse_candidate_id, uniqueness: {allow_blank: true}
  validates :email, :uniqueness => {:case_sensitive => false}
  validates :github_id, :uniqueness => { :case_sensitive => false, :allow_nil => true }
  validates :email, :first_name, :last_name, :presence => true
  validates :linkedin,
            format: {
              with: /\Ahttps?:\/\/.+/,
              message: "must be a full URL that starts with 'http'",
              allow_blank: true,
            }

  before_validation do
    unless auth_token?
      self.auth_token = SecureRandom.uuid
    end
  end

  has_many :enrollments
  has_many :student_deadlines
  has_many :cohorts, through: :enrollments
  has_many :submissions, dependent: :destroy
  has_many :employments, dependent: :destroy
  has_many :staffings, dependent: :destroy
  has_many :student_stories, dependent: :destroy
  has_many :student_snippets, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :zpd_responses
  has_one :employment_profile, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  scope :ordered, ->{ order('lower(first_name), lower(last_name)') }

  def self.for_cohort(cohort)
    joins(:enrollments).references(:enrollments).where(
      enrollments: {
        cohort_id: cohort,
        role: Enrollment.roles['student'],
        status: [
          Enrollment.statuses['enrolled'],
          Enrollment.statuses['graduated'],
          Enrollment.statuses['completed_without_guarantee'],
        ]
      }
    ).ordered
  end

  def password=(value)
    self.password_was_set = true
    super(value)
  end

  def password_confirmation=(value)
    self.password_confirmation_was_set = true
    super(value)
  end

  def current_cohort
    enrollments.enrolled.first.try(:cohort)
  end

  def cohort_exercises
    current_cohort ? current_cohort.order_added_exercises : []
  end

  def completed_exercises
    submissions.includes(:exercise).map(&:exercise)
  end

  def incomplete_exercises
    cohort_exercises - completed_exercises
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def github_url
    if github_username?
      "https://github.com/#{github_username}"
    end
  end

  def twitter_url
    if twitter =~ /https?:\/\//
      twitter
    else
      "https://twitter.com/#{twitter}"
    end
  end

  def is_employed?
    employments.active.present?
  end
end
