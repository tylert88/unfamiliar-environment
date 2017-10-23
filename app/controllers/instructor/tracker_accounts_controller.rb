class Instructor::TrackerAccountsController < InstructorRequiredController

  def index
    conn = Faraday.new(:url => 'https://www.pivotaltracker.com')

    response = conn.get do |req|
      req.url "/services/v5/accounts/#{ACCOUNT_ID}/memberships"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-TrackerToken'] = TRACKER_TOKEN
    end

    @members = JSON.parse(response.body, symbolize_names: true)
    @students = User.for_cohort(@cohort)
  end

  def create
    conn = Faraday.new(:url => 'https://www.pivotaltracker.com')

    response = conn.get do |req|
      req.url "/services/v5/accounts/#{ACCOUNT_ID}/memberships"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-TrackerToken'] = TRACKER_TOKEN
    end

    @members = JSON.parse(response.body, symbolize_names: true)
    @students = User.for_cohort(@cohort)
    member_emails = @members.map{|membership| membership[:person][:email].downcase }
    @students.each do |student|
      member = member_emails.include?(student.email.downcase)
      unless member
        conn.post do |req|
          req.url "/services/v5/accounts/#{ACCOUNT_ID}/memberships"
          req.headers['Content-Type'] = 'application/json'
          req.headers['X-TrackerToken'] = TRACKER_TOKEN
          req.body = {
            email: student.email,
            initials: student.first_name[0] + student.last_name[0],
            name: student.full_name,
            project_creator: true,
          }.to_json
        end
      end
    end

    redirect_to instructor_cohort_tracker_accounts_path, notice: "Tracker accounts were created successfully"
  end

  def destroy
    conn = Faraday.new(:url => 'https://www.pivotaltracker.com')

    response = conn.get do |req|
      req.url "/services/v5/accounts/#{ACCOUNT_ID}/memberships"
      req.headers['Content-Type'] = 'application/json'
      req.headers['X-TrackerToken'] = TRACKER_TOKEN
    end

    @members = JSON.parse(response.body, symbolize_names: true)
    @students = User.for_cohort(@cohort)
    student_emails = @students.map(&:email)

    @students.each do |student|
      member = @members.detect{|m| m[:person][:email].downcase == student.email.downcase }
      if member
        conn.delete do |req|
          req.url "/services/v5/accounts/#{ACCOUNT_ID}/memberships/#{member[:person][:id]}"
          req.headers['Content-Type'] = 'application/json'
          req.headers['X-TrackerToken'] = TRACKER_TOKEN
        end
      end
    end

    redirect_to instructor_cohort_tracker_accounts_path, notice: "Tracker accounts were deleted successfully"
  end

end
