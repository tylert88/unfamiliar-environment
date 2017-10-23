class PivotalTrackerOwnerAdder

  def initialize(cohort_id, email)
    @cohort_id, @email = cohort_id, email
  end

  def add
    students = User.for_cohort(@cohort_id)
    tracker_urls = StudentProject.where(user_id: students).where.not(class_project_id: nil).pluck(:tracker_url).reject(&:blank?)
    project_ids = tracker_urls.map do |tracker_url|
      tracker_url.sub(/https?:\/\/(www\.)?pivotaltracker\.com\/n\/projects\//, '')
    end

    conn = Faraday.new(:url => 'https://www.pivotaltracker.com')

    project_ids.each do |project_id|
      response = conn.post do |req|
        req.url "/services/v5/projects/#{project_id}/memberships"
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-TrackerToken'] = TRACKER_TOKEN
        req.body = {
          email: @email,
          role: 'owner',
        }.to_json
      end
    end
  end

end
