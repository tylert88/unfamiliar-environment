class CohortEpicsController < ApplicationController

  after_action :verify_authorized

  before_action do
    @epic = Epic.find(params[:epic_id])
    authorize(@epic)
  end

  def create
    @cohort_epic = CohortEpic.new(
      epic: @epic,
      cohort: Cohort.find(params[:cohort_id])
    )

    if @cohort_epic.save
      redirect_to(
        class_project_epic_path(@epic.class_project, @epic, anchor: "cohort-assignments"),
        notice: "Epic was assigned"
      )
    else
      redirect_to(
        class_project_epic_path(@epic.class_project, @epic),
        alert: @cohort_epic.errors.full_messages.join(", ")
      )
    end
  end

  def destroy
    @cohort_epic = CohortEpic.find( params[:id] )
    @cohort_epic.destroy
    redirect_to(
      class_project_epic_path(@epic.class_project, @epic, anchor: "cohort-assignments"),
      notice: "Epic was un-assigned"
    )
  end

end
