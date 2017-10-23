class Exercise < ActiveRecord::Base
  acts_as_taggable
  has_many :submissions, dependent: :destroy
  has_many :exercise_objectives
  has_many :objectives, through: :exercise_objectives
  belongs_to :curriculum

  validates :curriculum, presence: true
  validates :name, :github_repo, presence: true, uniqueness: {scope: :curriculum_id}

  enum response_type: [ :project, :file ]

  def submission_for(user_id)
    submissions.find_by(:user_id => user_id)
  end

  def github_repo_url
    if github_repo =~ /https?:\/\//
      github_repo
    else
      "https://github.com/gSchool/#{github_repo}"
    end
  end
end
