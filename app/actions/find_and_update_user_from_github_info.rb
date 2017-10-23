class FindAndUpdateUserFromGithubInfo
  def self.call(github_info)
    Runner.new(github_info).call
  end

  private

  class Runner
    def initialize(github_info)
      @github_info = github_info
    end

    def call
      user = find_by_github_id || find_by_email || find_by_github_nickname

      user && update_user(user)
    end

    private

    attr_reader :github_info

    def update_user(user)
      user.github_username = github_nickname
      user.email = github_email
      user.github_id = github_id unless user.github_id?
      user.save! if user.changed?

      user
    end

    def find_by_email
      return unless github_email.present?

      User.active.find_by(:email => github_email.downcase)
    end

    def find_by_github_id
      return unless github_id.present?

      User.active.find_by(:github_id => github_id)
    end

    def find_by_github_nickname
      return unless github_nickname.present?

      User.active.find_by(:github_username => github_nickname)
    end

    def github_id
      github_info["id"]
    end

    def github_email
      github_info["email"]
    end

    def github_nickname
      github_info["nickname"]
    end
  end
end
