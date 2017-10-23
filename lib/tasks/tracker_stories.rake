namespace :tracker do

  desc "Populates the tracker statuses"
  task populate: :environment do
    Cohort.current.each do |cohort|
      PivotalTrackerHarvester.new(cohort).harvest
    end
  end

end
