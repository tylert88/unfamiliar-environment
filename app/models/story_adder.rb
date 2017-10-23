class StoryAdder

  attr_reader :conn
  private :conn

  def initialize(current_user, project, epic, user)
    @token = current_user.pivotal_tracker_token
    @project = project
    @epic = epic
    @user = user
    @conn = Faraday.new(:url => 'https://www.pivotaltracker.com')
  end

  def project_id
    @project.tracker_url.sub(/https?:\/\/(www\.)?pivotaltracker\.com\/n\/projects\//, '')
  end

  def should_create?(student_story)
    !(student_story && student_story.pivotal_tracker_id? && exists_in_tracker?(student_story))
  end

  def exists_in_tracker?(student_story)
    response = conn.get do |req|
      req.url "/services/v5/projects/#{project_id}/stories/#{student_story.pivotal_tracker_id}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-TrackerToken'] = @token
    end

    response.success?
  end

  def create_stories
    records = StudentStory.where( story_id: @epic.stories, user_id: @user )

    student_stories = records.group_by(&:user_id).inject({}) do |hash, (user_id, student_stories)|
      hash[user_id] = student_stories.index_by(&:story_id)
      hash
    end

    successes, failures = [], []
    @epic.stories.each do |story|
      student_story = student_stories.fetch(@user.id, {})[story.id]

      if should_create?(student_story)
        response = conn.post do |req|
          req.url "/services/v5/projects/#{project_id}/stories"
          req.headers['Content-Type'] = 'application/json'
          req.headers['X-TrackerToken'] = @token
          post_data = {
            name: story.title,
            description: story.description,
            story_type: story.story_type,
            current_state: 'unstarted',
            labels: [@epic.label, @epic.category].select(&:present?).map{|label| {name: label}},
          }
          post_data[:estimate] = 1 if story.story_type == 'feature'
          req.body = post_data.to_json
        end

        student_story ||= StudentStory.new(
          class_project: @epic.class_project,
          user: @user,
          story: story,
          epic: @epic,
          current_state: 'unstarted',
        )

        json = JSON.parse(response.body, symbolize_names: true)

        if response.success?
          student_story.pivotal_tracker_id = json[:id]
          student_story.last_response_json = nil
          successes << student_story
        else
          student_story.last_response_json = json
          failures << student_story
        end
        student_story.save!
      end
    end
    return successes, failures
  end

end
