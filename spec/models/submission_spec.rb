require "rails_helper"

describe 'Submission' do
  describe "validations" do
    it "requires the github repo name to not have slashes" do
      submission = Submission.new(github_repo_name: "example/example")
      submission.valid?
      expect(submission.errors[:github_repo_name]).to be_present

      submission.github_repo_name = "some-repo-name"
      submission.save

      expect(submission.errors[:github_repo_name]).to_not be_present
    end

    it "requires the tracker url to be the full url of pivotal tracker" do
      submission = Submission.new(tracker_project_url: "something else")
      submission.valid?

      expect(submission.errors[:tracker_project_url]).to be_present

      submission.tracker_project_url = "http://google.com"
      submission.valid?

      expect(submission.errors[:tracker_project_url]).to be_present

      submission.tracker_project_url = "pivotaltracker.com"
      submission.valid?

      expect(submission.errors[:tracker_project_url]).to be_present

      submission.tracker_project_url = "http://www.pivotaltracker.com"
      submission.valid?

      expect(submission.errors[:tracker_project_url]).to_not be_present

      submission.tracker_project_url = "https://www.pivotaltracker.com"
      submission.valid?

      expect(submission.errors[:tracker_project_url]).to_not be_present
    end

    it "allows a blank pivotal tracker url" do
      submission = Submission.new(tracker_project_url: "")
      submission.valid?

      expect(submission.errors[:tracker_project_url]).to_not be_present
    end
  end
end
