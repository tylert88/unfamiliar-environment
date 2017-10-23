require 'rails_helper'

describe Exercise do

  describe "#github_repo_url" do

    it "shows the path to the url without duplicating the host / protocol" do
      @exercise = Exercise.new(github_repo: "https://github.com/gSchool/foo")

      actual = @exercise.github_repo_url

      expect(actual).to eq "https://github.com/gSchool/foo"
    end

    it "shows the path to the url with the host / protocol if github is not in the name" do
      @exercise = Exercise.new(github_repo: "some-repo")

      actual = @exercise.github_repo_url

      expect(actual).to eq "https://github.com/gSchool/some-repo"
    end

  end

end