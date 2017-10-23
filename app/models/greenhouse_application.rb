class GreenhouseApplication < ActiveRecord::Base

  belongs_to :cohort

  validates :cohort, presence: true
  validates :application_json, presence: true
  validates :candidate_json, presence: true

  def imported_user
    User.find_by_greenhouse_candidate_id(candidate_id)
  end

  def duplicate_user
    User.where('lower(email) = ?', email.downcase).first
  end

  def full_name
    "#{candidate_json['first_name']} #{candidate_json['last_name']}"
  end

  def candidate_id
    candidate_json['id']
  end

  def email
    candidate_json['email_addresses'].first.try(:[], 'value')
  end

  def phone
    candidate_json['phone_numbers'].first.try(:[], 'value')
  end

  def urls
    urls = candidate_json['website_addresses'].map{|info| info['value']}
    urls += candidate_json['social_media_addresses'].map{|info| info['value'] }
    urls = urls.select{|value| value.starts_with?('http')}
    urls.index_by {|url| field_name(url) }
  end

  def create_user
    urls = self.urls
    User.create!(
      first_name: candidate_json['first_name'],
      last_name: candidate_json['last_name'],
      email: email,
      role: :user,
      enrollments: [Enrollment.new(cohort: cohort, role: :student, status: :enrolled)],
      linkedin: urls['linkedin'],
      twitter: urls['twitter'],
      blog: urls['blog'],
      phone: urls['phone'],
      greenhouse_candidate_id: candidate_id,
    )
  end

  def field_name(url)
    if url.include?('linkedin')
      'linkedin'
    elsif url.include?('twitter')
      'twitter'
    elsif url.include?('github')
      'github'
    elsif url.include?('facebook')
      'facebook'
    else
      'blog'
    end
  end

end
