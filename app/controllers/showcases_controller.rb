class ShowcasesController < ApplicationController

  skip_before_action :require_signed_in_user

  layout 'public'

  def index
    @cohorts = Cohort.where(:showcase => true).order(:showcase_position)
  end

  def show
    @cohort = Cohort.find(params[:id])
  end
end
