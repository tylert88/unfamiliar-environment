class DailyPlansController < ApplicationController

  def index
    daily_plans = policy_scope(DailyPlan).where(cohort_id: @cohort)
    @grouped_plans = DailyPlan.grouped_by_week(daily_plans)
    authorize DailyPlan
  end

  def search
    @daily_plans = policy_scope(DailyPlan).where(cohort_id: @cohort).search(params[:q])
    authorize DailyPlan
  end

  def new
    @daily_plan = DailyPlan.new(date: params[:date])
    authorize @daily_plan
  end

  def create
    @daily_plan = DailyPlan.new(daily_plan_params)
    authorize @daily_plan
    @daily_plan.cohort = @cohort

    if @daily_plan.save
      redirect_to(
        cohort_daily_plan_path(@cohort, @daily_plan),
        notice: 'Daily Plan successfully created'
      )
    else
      render :new
    end
  end

  def show
    @daily_plan = DailyPlan.find_or_initialize_by(
      date: params[:id],
      cohort_id: @cohort.id
    )
    authorize(@daily_plan)

    pair_rotation = PairRotation.find_by(happened_on: params[:id])
    if pair_rotation
      current_pair = pair_rotation.pairs.detect do |pair|
        pair.include?(current_user.id)
      end
      if current_pair
        partner_id = (current_pair - [current_user.id]).first
        @partner = User.find_by(id: partner_id) || OpenStruct.new(full_name: 'Instructor')
      end
    end
  end

  def today
    redirect_to cohort_daily_plan_path(@cohort, Date.current.to_s)
  end

  def edit
    @daily_plan = DailyPlan.where(cohort_id: @cohort).find_by!(date: params[:id])
    authorize @daily_plan
  end

  def update
    @daily_plan = DailyPlan.where(cohort_id: @cohort).find_by!(date: params[:id])
    authorize @daily_plan

    if @daily_plan.update(daily_plan_params)
      redirect_to(
        cohort_daily_plan_path(@cohort, @daily_plan),
        notice: 'Daily Plan successfully updated'
      )
    else
      render :edit
    end
  end

  def destroy
    @daily_plan = DailyPlan.where(cohort_id: @cohort).find_by!(date: params[:id])
    authorize @daily_plan
    @daily_plan.try(:destroy)
    redirect_to(
      cohort_daily_plans_path(@cohort),
      notice: 'Daily Plan successfully deleted'
    )
  end

  private

  def daily_plan_params
    params.require(:daily_plan).permit(:date, :description)
  end
end
