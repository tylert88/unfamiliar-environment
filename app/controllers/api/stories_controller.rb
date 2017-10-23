module Api
  class StoriesController < BaseController

    def index
      render json: Story.all
    end


  end
end
