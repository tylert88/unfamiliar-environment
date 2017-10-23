namespace :github do
  desc "create the uber-team and add all the students"
  task teams: :environment do
    client = Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN'])
    user = client.user
    user.login

    # delete
    # g7-test-1
    # g7-test-2
    # g7-test-3
    # g7-test-4
    # g7-test-5
    # g7-test-6
    # g7-test-7
    # DenverPlatteMay2015Students

    cohort_repos = %w(
      g2 Students
      g3 Students
      g4-students
      g5 SF
      g6-students
      g7 Students
      g8-Boulder
      g9 Students
      g10 Students
      g11-fullstack
      g11_students
      g12_students
      g13_seattle
      g14_sanfrancisco
      g15_fortcollins
    )

    teams = client.org_teams('gschool')
    fullstack_team = "fullstack-students"
    students = []
    teams.each do |team|
      if team.name == fullstack_team
        fullstack_team = team
      end

      if cohort_repos.include?(team.name)
        students += client.team_members(team.id)
      end
    end

    students.each do |student|
      client.add_team_member(
        fullstack_team.id,
        student.login,
        :accept => "application/vnd.github.the-wasp-preview+json"
      )
    end
  end

  task repos: :environment do
    data = File.read(File.expand_path('~/Downloads/CurriculumSummary.html'))
    doc = Nokogiri::HTML(data)
    repos = []
    doc.css('a').each do |a|
      href = a['href'].split("?", 2).last.split("&").first.gsub("q=", "")
      if href.starts_with?('http')
        href = URI.unescape(href)
        uri = URI.parse(href)
        if uri.host == "github.com"
          path = uri.path
          parts = path.split('/')
          if parts[1].downcase == 'gschool'
            repos << parts[2]
          end
        end
      end
    end

    client = Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN'])
    user = client.user
    user.login

    teams = client.org_teams('gschool')
    fullstack_team = "fullstack-students"
    students = []
    teams.each do |team|
      if team.name == fullstack_team
        fullstack_team = team
      end
    end

    repos.each do |repo|
      p client.add_team_repo(fullstack_team.id, "gschool/#{repo}")
    end
  end
end
