class Student::ActionPlanEntriesController < ApplicationController

  def index
    user = current_user

    @entries = ActionPlanEntry.for_cohort_and_user(@cohort, user).order('created_at desc')
  end

end
