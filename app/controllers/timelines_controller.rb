class TimelinesController < ApplicationController

  def index
    our_cohorts = Cohort.all.to_a
    all_jobs = GreenhouseAPI.new.get_jobs

    campuses = Campus.all
    mappings = {
      "Boulder Campus (BD)" => campuses.detect{|campus|
        campus.name.include?("Boulder")
      },
      "Denver- Golden Triangle Campus (DG)" => campuses.detect{|campus|
        campus.name.include?("Denver") && campus.name.include?("Golden")
      },
      "San Francisco Campus (SF)" => campuses.detect{|campus|
        campus.name.include?("Francisco")
      },
      "Fort Collins" => campuses.detect{|campus|
        campus.name.include?("Fort") && campus.name.include?("Collins")
      },
    }

    greenhouse_cohorts = all_jobs.map do |job|
      next if our_cohorts.detect{|cohort| cohort.greenhouse_job_id == job[:id] }
      name = job[:name]
      location = job[:offices].first.try(:[], :name) || 'Unknown'
      start_date = job[:custom_fields][:program_start_date]
      end_date = job[:custom_fields][:program_end_date]
      campus = mappings[location] || Campus.new(name: location)
      Cohort.new(
        name: name,
        start_date: start_date,
        end_date: end_date,
        campus: campus
      )
    end.compact

    @cohorts = our_cohorts + greenhouse_cohorts.select{|cohort| cohort.start_date && cohort.end_date }
  end

end
