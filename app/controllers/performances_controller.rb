class PerformancesController < ApplicationController

  include MarkdownHelper
  after_action :verify_authorized

  def index
    authorize(Performance)

    if @cohort.curriculum_id.blank?
      redirect_to edit_cohort_path(@cohort), alert: "You must set a curriculum on this cohort"
      return
    end

    @curriculum = Curriculum.find(@cohort.curriculum_id)
  end

  def data
    authorize(Performance)

    @curriculum = Curriculum.find(@cohort.curriculum_id)
    @standards = @curriculum.standards.includes(:objectives, :subject).order('subjects.position ASC').ordered
    @students = User.for_cohort(@cohort).sort_by(&:full_name)
    @performances = Performance.where(user_id: @students).reduce({}) do |result, performance|
      result[performance.user_id] ||= {}
      result[performance.user_id][performance.objective_id] = {score: performance.score}
      result
    end
    render json: {
      standards: @standards.map{|standard|
        {
          id: standard.id,
          name: standard.name,
          tags: (standard.tags.sort << standard.subject.try(:name)).reject(&:blank?),
          standard_path: standard_path(standard),
          edit_standard_path: edit_standard_path(standard, return_to: 'performances', cohort_id: @cohort),
          objectives: standard.objectives.sort_by(&:position).map{|objective|
            {
              id: objective.id,
              name: objective.name,
              standard_id: objective.standard_id,
              objective_path: objective_path(objective),
              edit_objective_path: edit_objective_path(objective, return_to: 'performances', cohort_id: @cohort),
            }
          }
        }
      },
      performances: @performances,
      students: @students.map{|student|
        {
          id: student.id,
          full_name: student.full_name,
          performance_path: user_performances_path(student)
        }
      }
    }, serializer: nil
  end

  private

  def grouped_performances(performances)
    performances.reduce({}) do |result, performance|
      result[ [performance.objective.standard, performance.objective] ] ||= []
      result[ [performance.objective.standard, performance.objective] ] << performance.user
      result
    end.sort_by{|_, users| users.length * -1 }
  end

end
