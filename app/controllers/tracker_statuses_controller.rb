class TrackerStatusesController < ApplicationController

  before_action do
    @user = User.find(params[:user_id])
    unless current_user.instructor? || current_user == @user
      redirect_to root_path, notice: "You do not have access to that page"
    end
  end

  def index
    @tracker_statuses = TrackerStatus.where(user_id: @user)
  end

  def show
    @tracker_status = TrackerStatus.where(user_id: @user).find(params[:id])
    rankings = TrackerActivityRankings.new(
      @user.current_cohort,
      @tracker_status.class_project
    )
    @ranking = rankings.get_rankings[@tracker_status.id]
    @totals = rankings.get_totals
    @overall_averages = rankings.get_overall_averages
  end

end
