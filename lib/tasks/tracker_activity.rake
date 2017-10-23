namespace :tracker do
  namespace :activity do

    desc 'Print out things'
    task :debug => :environment do
      require 'pp'
      TrackerStatus.all.each do |record|
        pp record.activity_summary
        puts
      end
    end

    desc 'Groups activities by story id'
    task :process => :environment do
      require 'pp'

      TrackerStatus.all.each do |tracker_status|
        stories = {}
        activities = tracker_status.activities
        next unless activities.present?
        user = tracker_status.user
        activities.reverse.each do |activity|
          just_one_story = activity['primary_resources'].length < 2
          right_kind = %w(story_create_activity story_update_activity).include?(activity['kind'])
          if right_kind && just_one_story
            story_id = activity['primary_resources'].first['id']
            stories[story_id] ||= {}
            stories[story_id][:activities] ||= []
            stories[story_id][:activities] << activity
          end
        end
        result = {}
        stories.each do |id, info|
          result[id] = []
          info[:activities].each do |activity|
            if activity['kind'] == 'story_update_activity'
              change_type = nil
              story_type = nil
              activity['changes'].each do |change|
                original_state = change.fetch('original_values', {})['current_state']
                new_state = change.fetch('new_values', {})['current_state']
                if original_state && new_state
                  change_type = change['new_values']['current_state']
                  story_type = change['story_type']
                end
              end

              if change_type
                result[id] << {
                  story_type: story_type,
                  change_type: change_type,
                  performed_by: activity['performed_by']['name'],
                  occurred_at: activity['occurred_at'],
                }
                result[id] = result[id].sort_by{|hash| hash[:occurred_at].to_datetime }
              end
            end
          end
        end
        tracker_status.update!(activity_summary: result)
      end

      TrackerStatus.all.each do |tracker_status|
        summary = tracker_status.summarize
        tracker_status.total_rejections = summary[:total_rejections]
        tracker_status.total_stories = summary[:total_stories]
        tracker_status.stories_with_rejections = summary[:stories_with_rejections]
        tracker_status.total_started_stories = summary[:started_stories]
        tracker_status.total_started_bugs = summary[:started_bugs]
        tracker_status.save!
      end
    end

    desc 'Download activity for all tracker projects'
    task :download => :environment do |t, args|
      ClassProject.all.each do |class_project|
        Cohort.current.each do |cohort|
          users = User.for_cohort(cohort.id)
          student_projects = StudentProject.where(
            class_project_id: class_project.id,
            user_id: users
          ).to_a.select{|student_project| student_project.tracker_url.present? }

          student_projects.each do |student_project|
            user_id = student_project.user_id
            url = student_project.tracker_url
            puts "downloading for #{student_project.user.full_name}..."
            next unless url =~ /https?:\/\/(www\.)?pivotaltracker\.com\/n\/projects\//
            project_id = url.sub(/https?:\/\/(www\.)?pivotaltracker\.com\/n\/projects\//, '')
            next unless project_id.present?

            downloaded = 0
            total = 1
            page = 1

            activities = []

            while downloaded < total
              puts "  page #{page}..."
              conn = Faraday.new(:url => 'https://www.pivotaltracker.com')
              response = conn.get do |req|
                req.url "/services/v5/projects/#{project_id}/activity?limit=500&offset=#{downloaded}"
                req.headers['Content-Type'] = 'application/json'
                req.headers['X-TrackerToken'] = TRACKER_TOKEN
              end
              if response.success?
                total = response.headers["x-tracker-pagination-total"].to_i
                downloaded += response.headers["x-tracker-pagination-returned"].to_i
                activities += JSON.parse(response.body)
              else
                raise response.inspect
              end
              page += 1
            end

            tracker_status = TrackerStatus.find_or_initialize_by(
              user_id: user_id,
              class_project_id: class_project.id
            )

            tracker_status.update!(activities: activities)
          end
        end
      end
    end
  end
end
