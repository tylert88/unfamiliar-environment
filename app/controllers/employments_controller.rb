class EmploymentsController < ApplicationController

  before_action do
    @user = User.find(params[:user_id])
  end

  def new
    @employment = Employment.new(user: @user)
    authorize(@employment)
  end

  def create
    @employment = Employment.new(employment_params)
    authorize(@employment)
    @employment.user = @user
    if @employment.save
      redirect_to(
        user_path(@user, cohort_id: params[:cohort_id]),
        notice: "Employment added successfully"
      )
    else
      render :new
    end
  end

  def edit
    @employment = Employment.find(params[:id])
    authorize(@employment)
  end

  def update
    @employment = Employment.find(params[:id])
    authorize(@employment)
    if @employment.update(employment_params)
      redirect_to(
        user_path(@user, cohort_id: params[:cohort_id]),
        notice: "Employment was updated"
      )
    else
      render :edit
    end
  end

  def destroy
    @employment = Employment.find(params[:id])
    authorize(@employment)
    @employment.destroy
    redirect_to(
      user_path(@user, cohort_id: params[:cohort_id]),
      notice: 'Employment was deleted'
    )
  end

  private

  def employment_params
    params.require(:employment).permit(
      :company_name,
      :city,
      :company_type,
      :active,
      :company_url,
    )
  end

end
