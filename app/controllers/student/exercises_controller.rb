class Student::ExercisesController < ApplicationController

  def index
    user = current_user

    @exercises = @cohort.order_added_exercises.map do |exercise|
      StudentCohortExercise.new(user.id, exercise, @cohort)
    end
  end

  def show
    user = current_user
    exercise = Exercise.find(params[:id])

    @exercise = StudentCohortExercise.new(user.id, exercise, @cohort)
  end

  class StudentCohortExercise
    include ActionView::Helpers
    include Rails.application.routes.url_helpers

    def initialize(user_id, exercise, cohort)
      @user_id = user_id
      @exercise = exercise
      @cohort = cohort
    end

    delegate :name, :github_repo_url, :to_param, :tag_list, :to => :exercise

    def completed_text
      if completed?
        "✓"
      else
        ""
      end
    end

    def submission_text
      if completed?
        links = []
        if submission.github_repo_url
          links << link_to(submission.github_repo_name, submission.github_repo_url)
        end
        if submission.tracker_project_url.present?
          links << link_to("Tracker Project", submission.tracker_project_url)
        end
        "You've submitted: <br> #{links.join("<br>")}".html_safe
      else
        "You have not submitted a solution"
      end
    end

    def submission_link
      if completed?
        link_to("Edit", edit_cohort_exercise_submission_path(@cohort, exercise, submission), :class => "btn btn-info").html_safe
      else
        link_to("Submit Code", new_cohort_exercise_submission_path(@cohort, exercise), class: "btn btn-primary").html_safe
      end
    end

    private

    attr_reader :exercise, :user_id

    def completed?
      submission.present?
    end

    def submission
      @_submission ||= exercise.submission_for(user_id)
    end
  end
end
