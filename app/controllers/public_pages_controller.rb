class PublicPagesController < ApplicationController

  skip_before_action :require_signed_in_user

  layout 'public'

  def preparation_index
    @cohorts = Cohort.upcoming.announced
  end

  def preparation
    @cohort = Cohort.find_by_id(params[:id])
  end

end
