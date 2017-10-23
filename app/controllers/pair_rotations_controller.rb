class PairRotationsController < ApplicationController

  def index
    authorize(PairRotation)
    pair_rotations = PairRotation.for_cohort(@cohort).order(:position).to_a
    @todays_rotation = pair_rotations.find do |rotation|
      rotation.happened_on == Date.current
    end
    pair_rotations.delete(@todays_rotation)
    @assigned, @available = pair_rotations.partition do |rotation|
      rotation.happened_on
    end
    @users = User.for_cohort(@cohort).index_by(&:id)
  end

  def show
    @pair_rotation = PairRotation.find(params[:id])
    @users = User.for_cohort(@cohort).index_by(&:id)
    authorize(@pair_rotation)
  end

  def new
    @users = User.for_cohort(@cohort)
    @pair_rotation = PairRotation.new
    authorize(@pair_rotation)
  end

  def create
    pairs = params[:pairs].values.map{|pair|
      pair.map { |id| id.present? ? id.to_i : nil }
    }

    pair_rotation = PairRotation.new(
      cohort: @cohort,
      pairs: pairs,
    )
    authorize(pair_rotation)
    pair_rotation.save!
    redirect_to(
      cohort_pair_rotation_path(@cohort, pair_rotation),
      notice: "Pair rotation was created successfully"
    )
  end

  def random
    @users = User.for_cohort(@cohort)
    @pair_generator = PairGenerator.new(@users)
    @pairs = @pair_generator.random_pairs

  def assign
    @pair_rotation = PairRotation.find(params[:id])
    authorize(@pair_rotation)
    if @pair_rotation.update(happened_on: Date.current)
      flash[:notice] = 'Rotation was assigned'
    else
      flash[:alert] = @pair_rotation.errors.full_messages.join(", ")
    end
    redirect_to cohort_pair_rotations_path(@cohort)
  end

  def unassign
    @pair_rotation = PairRotation.find(params[:id])
    authorize(@pair_rotation)
    @pair_rotation.update(happened_on: nil)
    flash[:notice] = 'Rotation was unassigned'
    redirect_to cohort_pair_rotations_path(@cohort)
  end

  def generate
    authorize(PairRotation)
    PairRotation.generate(@cohort)
    redirect_to cohort_pair_rotations_path(@cohort), notice: 'Rotations were generated'
  end

  def destroy
    @pair_rotation = PairRotation.find(params[:id])
    authorize(@pair_rotation)
    @pair_rotation.destroy
    redirect_to cohort_pair_rotations_path(@cohort), notice: 'Rotation was deleted'
  end

end
