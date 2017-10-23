class VideosController < ApplicationController

  def index
    authorize :video, :index?

    @videos = Video.all.map{|video| {title: video.title, vimeo_id: video.vimeo_id} }
  end

end
