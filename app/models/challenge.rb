class Challenge
  attr_accessor :id, :directory_name, :github_url
  def initialize(id, directory_name, github_url)
    @id = id
    @directory_name = directory_name
    @github_url = github_url
  end

  def self.new_from_json(challenge_json)
    Challenge.new(challenge_json["_id"], challenge_json["directory_name"], challenge_json["github_url"])
  end

  def self.get_all
    conn = Faraday.new(:url => ENV['STUDENT_CHALLENGES_URL']) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.get '/challenges.json'
    challenges = JSON.parse(response.body)["challenges"].map do |challenge|
      self.new_from_json(challenge)
    end

    challenges = challenges.sort_by{|c| c.directory_name}
  end
end
