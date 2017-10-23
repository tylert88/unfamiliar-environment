class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception

  include Pundit
  include UserSessionHelper

  before_action :ensure_domain

  before_action :require_signed_in_user

  before_action do
    if params[:cohort_id]
      @cohort = Cohort.find(params[:cohort_id])
    end
  end

  rescue_from Pundit::NotAuthorizedError do
    redirect_to get_home_path, alert: "You do not have permission to access that page"
  end

  helper_method def assessments_in_progress
    unless defined?(@_assessments_in_progress)
      @_assessments_in_progress = nil
      if current_user && current_user.user?
        taken_assessments = TakenAssessment.in_progress.where(user_id: current_user)
        if taken_assessments.present?
          @_assessments_in_progress = taken_assessments
        end
      end
    end
    @_assessments_in_progress
  end

  def get_home_path
    if user_session.signed_in?
      if current_user.instructor?
        active_staffings = Staffing.where(user_id: current_user).active
        if active_staffings.length == 1
          today_cohort_daily_plans_path(active_staffings.first.cohort)
        else
          cohorts_path
        end
      elsif current_user.user? && current_user.current_cohort
        cohort_student_dashboard_path(current_user.current_cohort)
      elsif current_user.user?
        mentor_path(current_user)
      elsif current_user.galvanizer?
        timelines_path
      else
        logout_path
      end
    else
      root_path
    end
  end

  helper_method :get_home_path

  def ensure_domain
    if Rails.env.production? && request.host != ENV['HOST']
      querystring = request.query_parameters.to_query
      host_and_path = "https://#{ENV['HOST']}" + request.path
      url_with_query_string = [host_and_path, querystring].reject(&:blank?).join("?")
      redirect_to url_with_query_string, :status => 301 and return
    end
  end

end
