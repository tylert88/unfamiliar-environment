class PublicController < ApplicationController

  skip_before_action :require_signed_in_user

  layout 'public'

  def index
    cohorts = Cohort.where(showcase: true).order(:start_date)

    cohorts_in_second_half = cohorts.select { |cohort| (Date.current - cohort.start_date) >= ((cohort.end_date - cohort.start_date).to_i)/2 }

    students = User.joins(:enrollments).joins("left outer join employments on employments.user_id = users.id").where(
      "employments.user_id IS null AND enrollments.cohort_id IN (?)",
      cohorts_in_second_half.map(&:id)
    ).includes(:employments, :employment_profile).select { |user| user.employment_profile && user.employment_profile.is_complete_for_index_page? }

    employment_profiles = EmploymentProfile.visible.where(user_id: students)

    @locations = employment_profiles.flat_map do |profile|
      profile.preferred_locations.to_s.split("\n").map(&:strip)
    end.uniq.sort

    @students = StudentFilterer.filter_from_params(students.dup, params).shuffle


    @cohorts = Cohort.find(students.flat_map(&:enrollments).map(&:cohort_id).uniq)
  end

  def show
    @user = User.where(
      id: Enrollment.where(cohort_id: Cohort.where(showcase: true)).pluck(:user_id),
    ).find(params[:id])

    @projects = StudentProject.where(user_id: @user).visible.order(:position, :name)
    @employment = Employment.where(user_id: @user).active.first

    cohorts = Cohort.where(showcase: true).order(:start_date)
    cohorts_in_second_half = cohorts.select { |cohort| (Date.current - cohort.start_date) >= ((cohort.end_date - cohort.start_date).to_i)/2 }

    @students = User.joins(:enrollments).joins("left outer join employments on employments.user_id = users.id").where(
    "employments.user_id IS null AND enrollments.cohort_id IN (?)",
    cohorts_in_second_half.map(&:id)
    ).includes(:employments, :employment_profile).select { |user| user.employment_profile }.reject{ |user| user == @user }
  end
end
