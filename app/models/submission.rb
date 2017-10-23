class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise

  validates :user, :exercise, :github_repo_name, :presence => true
  validates :github_repo_name, :format => {:with => /\A[^\/]*\z/,
                                        :message => "Repo name cannot contain slashes"}
  validates :tracker_project_url, :format => {:with => /\Ahttps?:\/\/www\.pivotaltracker\.com(.*)\z/,
                                           :message => "This must be a pivotal tracker url",
                                           :allow_blank => true}

  def self.for_cohort(cohort)
    where(user_id: Enrollment.where(cohort_id: cohort).pluck(:user_id))
  end

  def user_name
    user.full_name
  end

  def github_repo_url
    if user.github_username?
      "https://github.com/#{user.github_username}/#{github_repo_name}"
    end
  end
end
