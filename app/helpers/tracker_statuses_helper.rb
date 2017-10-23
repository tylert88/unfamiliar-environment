module TrackerStatusesHelper

  def total_stories_json(totals)
    result = [['Student', 'Value']]
    result += totals[:total_stories].map do |user, value|
      [current_name_or_classmate(user), value]
    end
    result.to_json
  end

  def total_rejections_json(totals)
    result = [['Student', 'Value']]
    result += totals[:total_rejections].map do |user, value|
      [current_name_or_classmate(user), value]
    end
    result.to_json
  end

  def stories_with_rejections_json(totals)
    result = [['Student', 'Value']]
    result += totals[:stories_with_rejections].map do |user, value|
      [current_name_or_classmate(user), value]
    end
    result.to_json
  end

  def with_without_rejections_json(totals)
    result = [['Student', 'Value']]
    result += totals[:story_rejection_ratio].map do |user, value|
      [current_name_or_classmate(user), value]
    end
    result.to_json
  end

  def average_rejections_per_story_json(totals)
    result = [['Student', 'Value']]
    result += totals[:rejections_per_story].map do |user, value|
      [current_name_or_classmate(user), value]
    end
    result.to_json
  end

  def total_started_stories_json(totals)
    result = [['Student', 'Value']]
    result += totals[:started_stories].map do |user, value|
      [current_name_or_classmate(user), value]
    end
    result.to_json
  end

  def total_started_bugs_json(totals)
    result = [['Student', 'Value']]
    result += totals[:started_bugs].map do |user, value|
      [current_name_or_classmate(user), value]
    end
    result.to_json
  end

end
