class CampusesController < ApplicationController

  def index
    @campuses = Campus.order('lower(name)')
    authorize(Campus)
  end

  def new
    @campus = Campus.new
    authorize(@campus)
  end

  def create
    @campus = Campus.new(campus_params)
    authorize(@campus)

    if @campus.save
      redirect_to(
        campuses_path,
        notice: 'Campus was added successfully'
      )
    else
      render :new
    end
  end

  def edit
    @campus = Campus.find(params[:id])
    authorize(@campus)
  end

  def update
    @campus = Campus.find(params[:id])
    authorize(@campus)

    if @campus.update(campus_params)
      redirect_to(
        campuses_path,
        notice: 'Campus was updated successfully'
      )
    else
      render :edit
    end
  end

  def destroy
    @campus = Campus.find(params[:id])
    authorize(@campus)
    if @campus.destroy
      flash[:notice] = 'Campus removed successfully'
    else
      flash[:alert] = 'Campus could not be destroyed'
    end
    redirect_to(campuses_path)
  end

  private

  def campus_params
    params.require(:campus).permit(
      :name,
      :google_maps_location,
      :directions,
    )
  end
end
