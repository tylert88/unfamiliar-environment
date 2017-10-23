namespace :tracker do
  desc 'A task to give access to a student\'s tracker projects'
  task :create_memberships, [:cohort_id, :email] => :environment do |t, args|
    PivotalTrackerOwnerAdder.new(args[:cohort_id], args[:email]).add
  end
end
