class Instructor::CurriculumsController < ApplicationController

  after_action :verify_authorized

  def index
    @curriculums = Curriculum.all
    authorize(@curriculums)
  end

  def new_import
    @curriculum = Curriculum.find(params[:id])
    authorize(@curriculum)
  end

  def import
    @curriculum = Curriculum.find(params[:id])
    authorize(@curriculum)
    @tags = params[:import][:tags]
    @data = params[:import][:data]

    if @tags.blank? || @data.blank?
      flash.now[:alert] = "Tags and data can't be blank"
      render :new_import
      return
    end

    begin
      ActiveRecord::Base.transaction do
        standard = nil
        @data.strip.gsub("\r\n", "\n").split("\n").each do |line|
          if standard.nil?
            standard = Standard.create!(
              curriculum: @curriculum,
              name: line,
              tags: @tags.split(",").map(&:strip)
            )
          elsif line.blank?
            standard = nil
          else
            Objective.create!( standard: standard, name: line )
          end
        end
      end
      redirect_to curriculum_path(@curriculum), notice: 'Standards and objectives were imported successfully'
    rescue Exception => e
      flash.now[:alert] = "Could not import data - #{e.message}"
      render :new_import
    end
  end

  def new
    @curriculum = Curriculum.new
    authorize(@curriculum)
  end

  def create
    @curriculum = Curriculum.new(curriculum_params)
    authorize(@curriculum)

    if @curriculum.save
      redirect_to(
        curriculum_path(@curriculum),
        notice: 'Curriculum was added successfully'
      )
    else
      render :new
    end
  end

  def show
    @curriculum = Curriculum.find(params[:id])
    @standards = @curriculum.standards.includes(:objectives, :subject).ordered
    authorize(@curriculum)
  end

  def progress
    @curriculum = Curriculum.find(params[:id])
    @standards = @curriculum.standards.includes(:objectives).ordered

    @standard_completions, @objective_completions = {}, {}
    @standards.each do |standard|
      fields = [standard.description?, standard.resources?, standard.description?]
      @standard_completions[standard.id] = (fields.select{|x|x}.length / fields.length.to_f * 100).to_i

      standard.objectives.each do |objective|
        fields = [objective.description?, objective.resources?, objective.description?]
        @objective_completions[objective.id] = (fields.select{|x|x}.length / fields.length.to_f * 100).to_i
      end
    end

    authorize(@curriculum)
  end

  def edit
    @curriculum = Curriculum.find(params[:id])
    authorize(@curriculum)
  end

  def update
    @curriculum = Curriculum.find(params[:id])
    authorize(@curriculum)

    if @curriculum.update(curriculum_params)
      redirect_to(
        curriculum_path(@curriculum),
        notice: 'Curriculum was updated successfully'
      )
    else
      render :edit
    end
  end

  def activity
    @curriculum = Curriculum.find(params[:id])
    @curriculum_notifications = Kaminari.paginate_array(CurriculumNotification.where(curriculum_id: @curriculum.id).order(:created_at).reverse).page params[:page]
    authorize(@curriculum)
  end

  private

  def curriculum_params
    params.require(:curriculum).permit( :name, :description, :version )
  end

end
