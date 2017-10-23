class ZpdResponse < ActiveRecord::Base
  validates :user_id, :date, :response, presence: true
  validate :validate_uniqueness_of_learning_experience

  belongs_to :user
  belongs_to :resource, polymorphic: true
  RESPONSES = {
      0 => "Too Easy!",
      1 => "In My ZPD",
      2 => "Too Challenging"
  }

  def self.for_cohort(cohort)
    ZpdResponse.where(user_id: User.for_cohort(cohort).map(&:id)).order(:date)
  end

  def self.build_zpd_responses(zpd_responses)
    results = []

    zpd_responses.map(&:date).uniq.each do |date|
      results << {date: date, RESPONSES[0] => 0, RESPONSES[1] => 0, RESPONSES[2] => 0, count: 0}
    end

    zpd_responses.each do |response|
      results.each do |result|
        if result[:date] == response.date
          result[RESPONSES[response.response]] += 1
          result[:count] += 1
        end
      end
    end
    results
  end

  def self.gather_data_for_user(user_id)
    responses = ZpdResponse.where(user_id: user_id)
    results = RESPONSES.map do |i, label|
      {
        "label" => label,
        "response" => i,
        "count" => "0"
      }
    end

    responses.each do |response|
      results.each do |result|
        if result["response"] == response.response
          (result["count"] = result["count"].to_i + 1)
        end
      end
    end
    results.reject { |r| r["count"] == "0"}.to_json
  end

  def self.gather_data_for_resource(resource)
    responses = ZpdResponse.where(resource: resource)
    results = RESPONSES.map do |i, label|
      {
        "label" => label,
        "response" => i,
        "count" => "0"
      }
    end

    responses.each do |response|
      results.each do |result|
        if result["response"] == response.response
          (result["count"] = result["count"].to_i + 1)
        end
      end
    end
    results.reject { |r| r["count"] == "0"}.to_json
  end

  private

  def validate_uniqueness_of_learning_experience
    unless self.resource.nil? && self.resource_id.nil?
      zpds = self.user.zpd_responses
      results = zpds.map do |zpd|
        [zpd.resource, zpd.resource_id]
      end
      if results.include?([self.resource, self.resource_id])
        errors[:base] << "ZPD Already Exists"
      end
    end
  end
end