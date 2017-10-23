namespace :db do
  namespace :seed do

    desc 'Seeds the app with daily plans'
    task daily_plans: :environment do
      DailyPlan.delete_all
      Cohort.all.each do |cohort|
        (2.months.ago.to_date..2.months.from_now.to_date).each do |date|
          if (1..5).include?(date.wday)
            DailyPlan.create!(
              cohort: cohort,
              date: date,
              description: "Sample content"
            )
          end
        end
      end
    end

    desc 'Seeds the app the fullstack curriculum'
    task full_stack_curriculum: :environment do
      curriculum = Curriculum.find_or_create_by!(name: 'Full Stack', description: 'full stack')
      data = JSON.parse(File.read(Rails.root.join('db/seeds/full-stack-curriculum.json')), symbolize_names: true)
      data.each do |unit_name, data|
        tags = data[:tags] + [unit_name]
        data[:standards].each do |standard_data|
          standard = Standard.create!(
            curriculum: curriculum,
            name: standard_data[:name],
            tags: tags
          )
          standard_data[:objectives].each do |objective|
            Objective.create!(
              standard: standard,
              name: objective
            )
          end
        end
      end
    end

    desc 'Seeds the app the gu curriculum'
    task gu_curriculum: :environment do
      curriculum = Curriculum.find_or_create_by!(name: 'gU', description: 'gU')
      data = JSON.parse(File.read(Rails.root.join('db/seeds/gu-curriculum.json')), symbolize_names: true)
      data.each do |unit_name, data|
        tags = data[:tags] + [unit_name]
        data[:standards].each do |standard_data|
          standard = Standard.create!(
            curriculum: curriculum,
            name: standard_data[:name],
            tags: tags
          )
          standard_data[:objectives].each do |objective|
            Objective.create!(
              standard: standard,
              name: objective
            )
          end
        end
      end
    end

    desc 'Seeds the app the gu prework curriculum'
    task gu_prework: :environment do
      curriculum = Curriculum.find_or_create_by!(name: 'gU', description: 'gU')
      data = JSON.parse(File.read(Rails.root.join('db/seeds/gu-prework.json')), symbolize_names: true)
      data.each do |unit_name, data|
        tags = data[:tags] + [unit_name]
        data[:standards].each do |standard_data|
          standard = Standard.create!(
            curriculum: curriculum,
            name: standard_data[:name],
            tags: tags
          )
          standard_data[:objectives].each do |objective|
            Objective.create!(
              standard: standard,
              name: objective
            )
          end
        end
      end
    end

    desc 'Seeds the app with data that the acceptor can match'
    task acceptor: :environment do
      raise 'This can only be run in development!!' unless Rails.env.development?

      student = nil
      if File.exists?(Rails.root.join('.seedrc'))
        puts "Reading config values from .seedrc..."
        config = YAML.load_file(Rails.root.join(".seedrc"))
        student = User.find_by!(email: config[:student][:github_email])
      else
        puts "Could not find .seedrc"
        puts "Please run `rake db:drop db:create db:structure:load db:seed` to ensure you have the correct setup"
        raise 'invalid setup'
      end

      unless File.exists?(Rails.root.join(".acceptorrc"))
        print "Enter the URL of the tracker project you are testing with: "
        tracker_url = $stdin.gets.chomp

        print "Enter the production URL you want to use (defaults to localhost:3001): "
        production_url = $stdin.gets.chomp.presence || 'http://localhost:3001'

        require 'io/console'
        print "Enter your tracker token: "
        tracker_token = STDIN.noecho(&:gets).chomp

        config = {
          tracker_url: tracker_url,
          production_url: production_url,
          tracker_token: tracker_token,
        }

        puts "Writing config values to .acceptorrc..."
        File.open(Rails.root.join(".acceptorrc"), "w") do |f|
          f.puts config.to_yaml
        end
      end

      puts "Reading config values from .acceptorrc..."
      config = YAML.load_file(Rails.root.join(".acceptorrc"))
      tracker_url = config[:tracker_url]
      production_url = config[:production_url]
      tracker_token = config[:tracker_token]

      student.update!(pivotal_tracker_token: tracker_token)

      StudentProject.destroy_all
      StudentStory.destroy_all
      Story.destroy_all
      Epic.destroy_all

      cohort = Cohort.order(:id).first
      gcamp = ClassProject.find_or_initialize_by(name: 'gCamp')
      gcamp.save!
      pages_epic = Epic.create!(name: 'Basic Pages', class_project: gcamp, label: 'pages')
      stories = [
        Story.create!( epic: pages_epic, slug: 'homepage', title: 'Homepage'),
        Story.create!( epic: pages_epic, slug: 'about-page', title: 'About'),
        Story.create!( epic: pages_epic, slug: 'terms-page', title: 'Terms'),
        Story.create!( epic: pages_epic, slug: 'faq-page', title: 'FAQ'),
        Story.create!( epic: pages_epic, slug: 'quotes', title: 'Quotes'),
        Story.create!( epic: pages_epic, slug: 'social-links', title: 'Social Links'),
        Story.create!( epic: pages_epic, slug: 'tasks-scaffold', title: 'Tasks Scaffold'),
      ]

      project_id = tracker_url.sub(/https?:\/\/(www\.)?pivotaltracker\.com\/n\/projects\//, '')
      conn = Faraday.new(:url => 'https://www.pivotaltracker.com')
      response = conn.get do |req|
        req.url "/services/v5/projects/#{project_id}/stories"
        req.headers['Content-Type'] = 'application/json'
        req.headers['X-TrackerToken'] = tracker_token
      end
      require 'pp'
      stories = JSON.parse(response.body, symbolize_names: true)
      if stories.any?
        puts "You are about to delete the following stories from Pivotal Tracker:"
        stories.each do |story|
          puts "  #{story[:name]}"
        end
        puts
        print "Are you sure (y/n)? "
        if $stdin.gets.chomp.downcase == "y"
          puts
          stories.each do |story|
            puts "deleting #{story[:name]}..."
            conn.delete do |req|
              req.url "/services/v5/projects/#{project_id}/stories/#{story[:id]}"
              req.headers['Content-Type'] = 'application/json'
              req.headers['X-TrackerToken'] = tracker_token
            end
          end
        end
      end

      project = StudentProject.create!(
        user: student,
        class_project: gcamp,
        name: 'gCamp',
        tracker_url: tracker_url,
        production_url: production_url
      )

      puts "Adding stories to tracker..."
      student_stories, failures = StoryAdder.new(student, project, pages_epic, student).create_stories

      puts "Delivering all stories..."
      student_stories.each do |story|
        conn.put do |req|
          req.url "/services/v5/projects/#{project_id}/stories/#{story.pivotal_tracker_id}"
          req.headers['Content-Type'] = 'application/json'
          req.headers['X-TrackerToken'] = tracker_token
          req.body = { current_state: 'delivered' }.to_json
        end
      end

      puts "URLs:"
      puts "  Instructor: http://localhost:3000/class_projects/#{gcamp.id}/epics/#{pages_epic.id}"
      puts "  Student:    http://localhost:3000/users/#{student.id}/epics/#{pages_epic.id}"
      puts "  API:        http://localhost:3000/api/student_projects?cohort_id=#{cohort.id}&class_project_id=#{gcamp.id}"
    end
  end
end
