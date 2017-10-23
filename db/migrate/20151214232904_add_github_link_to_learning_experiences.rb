class AddGithubLinkToLearningExperiences < ActiveRecord::Migration
  def change
    add_column :learning_experiences, :github_repo, :string
  end
end
