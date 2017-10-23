class GreenhouseAPI

  def initialize(api_key = ENV['GREENHOUSE_HARVEST_API_KEY'])
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
