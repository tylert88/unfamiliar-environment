module Api
  class ClassProjectsController < BaseController

    def index
      render json: ClassProject.all
    end

  end
end
