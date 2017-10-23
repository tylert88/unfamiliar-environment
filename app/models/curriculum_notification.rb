class CurriculumNotification < ActiveRecord::Base
  enum status: [:created, :updated, :deleted]
  belongs_to :user
end
