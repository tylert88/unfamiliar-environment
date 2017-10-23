class StudentChallenge
  attr_accessor :challenge_id, :auth_token, :passing, :failing

  def initialize(challenge_id, auth_token, passing, failing)
    @challenge_id = challenge_id
    @auth_token = auth_token
    @passing = passing
    @failing = failing
  end

  def self.new_from_json(student_challenge_json)
    StudentChallenge.new(student_challenge_json["challenge_id"], student_challenge_json["auth_token"], student_challenge_json["passing"], student_challenge_json["failing"])
  end

  def self.for_user(user)
    conn = Faraday.new(:url => ENV['STUDENT_CHALLENGES_URL']) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.get '/student_challenges.json?auth_token=' + user.auth_token
    student_challenges = JSON.parse(response.body)["studentChallenges"].map do |student_challenge|
      StudentChallenge.new_from_json(student_challenge)
    end
  end
end