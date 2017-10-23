class StudentProject < ActiveRecord::Base

  enum visibility: [:hidden, :visible]

  mount_uploader :screenshot, ScreenshotUploader

  belongs_to :user
  belongs_to :class_project
  validates :name, presence: true
  validates :user, presence: true
  validates :github_url,
            format: {
              with: /\Ahttps?:\/\/.+/,
              message: "must be a full URL that starts with 'http'",
              allow_blank: true,
            }
  validates :tracker_url,
            format: {
              with: /\Ahttps?:\/\/.+/,
              message: "must be a full URL that starts with 'http'",
              allow_blank: true,
            }
  validates :production_url,
            format: {
              with: /\Ahttps?:\/\/.+/,
              message: "must be a full URL that starts with 'http'",
              allow_blank: true,
            }

  def self.for_user(user)
    where(user_id: user)
  end

  def student_stories
    StudentStory.where( user_id: user, class_project: class_project ).includes(:story)
  end

  def tracker_project_id
    regex = /https?:\/\/(www\.)?pivotaltracker\.com\/n\/projects\//
    if tracker_url? && tracker_url =~ regex
      tracker_url.sub(regex, '')
    end
  end

end
