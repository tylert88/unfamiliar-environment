class TrackerStatus < ActiveRecord::Base

  belongs_to :user
  belongs_to :class_project
  validates :class_project, presence: true
  validates :user, presence: true, uniqueness: {scope: :class_project}
  validates :delivered, presence: true, numericality: true
  validates :accepted, presence: true, numericality: true
  validates :rejected, presence: true, numericality: true
  validates :started, presence: true, numericality: true
  validates :unstarted, presence: true, numericality: true
  validates :unscheduled, presence: true, numericality: true
  validates :finished, presence: true, numericality: true

  def summarize
    rejections = []
    stories_with_rejections = []
    started_features = 0
    started_bugs = 0

    stories = activity_summary || []
    stories.each do |story_id, activities|
      if activities.present?
        if activities.first['story_type'] == 'feature'
          started_features += 1
        elsif
          started_bugs += 1
        end
      end
      story_rejections = activities.select{|activity|
        activity['change_type'] == 'rejected'
      }.length
      stories_with_rejections << story_id if story_rejections > 0
      rejections << story_rejections
    end

    {
      total_rejections: rejections.sum,
      total_stories: stories.length,
      stories_with_rejections: stories_with_rejections.length,
      with_without_rejections: (stories_with_rejections.length.to_f / stories.length).round(2),
      average_rejections_per_story: (rejections.sum / stories.length.to_f).round(2),
      started_stories: started_features,
      started_bugs: started_bugs,
    }
  end

  def with_without_rejections
    (stories_with_rejections.to_f / total_stories).round(2)
  end

  def average_rejections_per_story
    (total_rejections.to_f / total_stories).round(2)
  end

end
