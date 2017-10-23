module Api
  class CohortsController < BaseController

    def index
      render json: Cohort.all
    end

    def current
      render json: Cohort.current
    end

  end
end
