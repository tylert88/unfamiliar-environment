class UserEpicsController < ApplicationController

  before_action do
    @user = User.find(params[:user_id])
  end

  def index
    @epics = Epic
      .where(id: CohortEpic.where(cohort_id: @user.current_cohort).pluck(:epic_id))
      .includes(:class_project)
      .group_by(&:class_project)
  end

  def show
    @epic = Epic
      .where(id: CohortEpic.where(cohort_id: @user.current_cohort).pluck(:epic_id))
      .find(params[:id])

    @project = StudentProject.where(
      user_id: @user,
      class_project_id: @epic.class_project
    ).first
    @student_stories = StudentStory.where(
      story_id: @epic.stories,
      user_id: @user,
    ).index_by(&:story_id)
  end

  def add_to_tracker
    @epic = Epic.find(params[:id])
    @project = StudentProject.where(
      user_id: @user,
      class_project_id: @epic.class_project
    ).first

    successes, failures = StoryAdder.new(current_user, @project, @epic, @user).create_stories

    if successes.present?
      flash[:notice] = "#{view_context.pluralize successes.length, "story"} synced successfully"
    end

    if failures.present?
      flash[:alert] = "#{view_context.pluralize failures.length, "story"} could not be synced"
    end

    if successes.empty? && failures.empty?
      flash[:notice] = "Nothing to sync!  All up-to-date."
    end

    redirect_to user_epic_path(@user, @epic)
  end

end
