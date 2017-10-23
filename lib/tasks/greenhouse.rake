namespace :greenhouse do

  desc "Populates the greenhouse applications for upcoming cohorts"
  task harvest: :environment do
    Cohort.upcoming.each do |cohort|
      if cohort.greenhouse_job_id
        GreenhouseHarvester.new(cohort).run
      end
    end
  end

end
