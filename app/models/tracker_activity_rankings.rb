class TrackerActivityRankings

  def initialize(cohort, class_project)
    @cohort = cohort
    @class_project = class_project
  end

  def get_overall_averages
    users = User.for_cohort(@cohort)
    tracker_statuses = TrackerStatus.where(user_id: users, class_project_id: @class_project)

    total_stories = tracker_statuses.map(&:total_stories)
    stories_with_rejections = tracker_statuses.map(&:stories_with_rejections)
    total_rejections = tracker_statuses.map(&:total_rejections)
    story_rejection_ratio = tracker_statuses.map(&:with_without_rejections)
    rejections_per_story = tracker_statuses.map(&:average_rejections_per_story)
    started_stories = tracker_statuses.map(&:total_started_stories)
    started_bugs = tracker_statuses.map(&:total_started_bugs)

    OpenStruct.new(
      :total_stories => (total_stories.sum / total_stories.length.to_f).round(2),
      :stories_with_rejections => (stories_with_rejections.sum / stories_with_rejections.length.to_f).round(2),
      :total_rejections => (total_rejections.sum / total_rejections.length.to_f).round(2),
      :with_without_rejections => (story_rejection_ratio.sum / story_rejection_ratio.length.to_f).round(2),
      :average_rejections_per_story => (rejections_per_story.sum / rejections_per_story.length.to_f).round(2),
      :total_started_stories => (started_stories.sum / started_stories.length.to_f).round(2),
      :total_started_bugs => (started_bugs.sum / started_bugs.length.to_f).round(2),
    )
  end

  def get_rankings
    users = User.for_cohort(@cohort)
    tracker_statuses = TrackerStatus.where(user_id: users, class_project_id: @class_project)

    total_stories = tracker_statuses.map(&:total_stories)
    stories_with_rejections = tracker_statuses.map(&:stories_with_rejections)
    total_rejections = tracker_statuses.map(&:total_rejections)
    story_rejection_ratio = tracker_statuses.map(&:with_without_rejections)
    rejections_per_story = tracker_statuses.map(&:average_rejections_per_story)
    started_stories = tracker_statuses.map(&:total_started_stories)
    started_bugs = tracker_statuses.map(&:total_started_bugs)

    result = {}
    tracker_statuses.each do |tracker_status|
      result[tracker_status.id] = OpenStruct.new(
        :user => tracker_status.user,
        # the more the better
        :total_stories => total_stories.sort.reverse.index(tracker_status.total_stories) + 1,

        # the fewer the better
        :stories_with_rejections => stories_with_rejections.sort.index(tracker_status.stories_with_rejections) + 1,

        # the fewer the better
        :total_rejections => total_rejections.sort.index(tracker_status.total_rejections) + 1,

        # the lower the better
        :with_without_rejections => story_rejection_ratio.sort.index(tracker_status.with_without_rejections) + 1,

        # the fewer the better
        :average_rejections_per_story => rejections_per_story.sort.index(tracker_status.average_rejections_per_story) + 1,

        # the more the better
        :total_started_stories => started_stories.sort.reverse.index(tracker_status.total_started_stories) + 1,

        # the fewer the better
        :total_started_bugs => started_bugs.sort.index(tracker_status.total_started_bugs) + 1,
      )
    end
    result
  end

  def get_totals
    users = User.for_cohort(@cohort)
    tracker_statuses = TrackerStatus.where(user_id: users, class_project_id: @class_project)

    {
      total_stories: tracker_statuses.map{|tracker_status| [tracker_status.user, tracker_status.total_stories] }.sort_by(&:last).reverse,
      stories_with_rejections: tracker_statuses.map{|tracker_status| [tracker_status.user, tracker_status.stories_with_rejections] }.sort_by(&:last),
      total_rejections: tracker_statuses.map{|tracker_status| [tracker_status.user, tracker_status.total_rejections] }.sort_by(&:last),
      story_rejection_ratio: tracker_statuses.map{|tracker_status| [tracker_status.user, tracker_status.with_without_rejections] }.sort_by(&:last),
      rejections_per_story: tracker_statuses.map{|tracker_status| [tracker_status.user, tracker_status.average_rejections_per_story] }.sort_by(&:last),
      started_stories: tracker_statuses.map{|tracker_status| [tracker_status.user, tracker_status.total_started_stories] }.sort_by(&:last).reverse,
      started_bugs: tracker_statuses.map{|tracker_status| [tracker_status.user, tracker_status.total_started_bugs] }.sort_by(&:last),
    }
  end

end
