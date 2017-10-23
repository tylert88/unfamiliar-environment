class GreenhouseHarvester

  def initialize(cohort, api_key = ENV['GREENHOUSE_HARVEST_API_KEY'])
    @cohort = cohort
    @conn = Faraday.new(:url => 'https://harvest.greenhouse.io')
    @conn.basic_auth(api_key, '')
  end

  def get_jobs
    next_url = "/v1/jobs"
    responses = []
    while next_url
      response = @conn.get { |req| req.url next_url }
      next_url = get_next_url(response)
      handle_rate_limit(response)

      jobs = JSON.parse(response.body, symbolize_names: true)
      responses += jobs
    end
    responses
  end

  def run
    applications = get_applications
    candidates = get_candidates(applications)

    GreenhouseApplication.transaction do
      GreenhouseApplication.where(cohort_id: @cohort).delete_all
      candidates.each do |candidate|
        GreenhouseApplication.create!(
          cohort: @cohort,
          application_json: candidate[:applications].first,
          candidate_json: candidate
        )
      end
    end
  end

  def get_applications
    next_url = "/v1/applications?per_page=100"

    responses = []
    while next_url
      response = @conn.get { |req| req.url next_url }
      next_url = get_next_url(response)
      handle_rate_limit(response)

      applications = JSON.parse(response.body, symbolize_names: true)
      responses += applications.select do |application|
        application[:status] == "hired" &&
          application[:jobs].any?{|job| job[:id] == @cohort.greenhouse_job_id }
      end
    end
    responses
  end

  def get_candidates(applications = get_applications)
    candidate_applications = applications.group_by do |application|
      application[:candidate_id]
    end

    candidates = []
    candidate_applications.each do |candidate_id, apps|
      response = @conn.get { |req| req.url "/v1/candidates/#{candidate_id}" }
      candidate = JSON.parse(response.body, symbolize_names: true)
      candidate[:applications] = apps
      candidates << candidate
      handle_rate_limit(response)
    end
    candidates
  end

  private

  def handle_rate_limit(response)
    sleep 2 if response.headers['X-RateLimit-Remaining'].to_i < 50
  end

  def get_next_url(response)
    link = response.headers['Link']
    parts = link.split(',')
    rels = {}
    parts.each do |part|
      url_string, rel_string = part.split(';').map(&:strip)
      rel = rel_string.split('=').last.gsub('"', '')
      url = url_string.gsub(/\<|\>/, '')
      rels[rel] = url
    end
    rels['next']
  end

end
