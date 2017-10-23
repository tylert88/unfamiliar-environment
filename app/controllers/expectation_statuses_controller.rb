class ExpectationStatusesController < ApplicationController

  before_action do
    @user = User.find(params[:user_id])
    @expectation = Expectation.find(params[:expectation_id])
  end

  def create
    @status = ExpectationStatus.new(
      params.require(:expectation_status).permit(:notes, :on_track).merge(
        user: @user,
        expectation: @expectation,
        cohort: @user.current_cohort,
        status: :draft,
        author: current_user
      )
    )
    authorize(@status)

    if @status.save
      redirect_to(
        user_expectations_path(@user, anchor: "expectation-#{@expectation.id}"),
        notice: 'Expectation Status was added successfully'
      )
    else
      redirect_to(
        user_expectations_path(@user),
        alert: 'Trouble saving expectation status'
      )
    end
  end

  def edit
    @status = ExpectationStatus.find(params[:id])
    authorize(@status)
  end

  def update
    @status = ExpectationStatus.find(params[:id])
    authorize(@status)

    if @status.update(params.require(:expectation_status).permit(:notes, :on_track))
      redirect_to(
        user_expectations_path(@user, anchor: "expectation-#{@expectation.id}"),
        notice: 'Expectation status was updated successfully'
      )
    else
      render :edit
    end
  end

  def publish
    @status = ExpectationStatus.find(params[:id])
    authorize(@status)

    @status.update!(status: :published)
    redirect_to(
      user_expectations_path(@user, anchor: "expectation-#{@expectation.id}"),
      notice: 'Expectation status was published successfully'
    )
  end

  def mark_as_read
    @status = ExpectationStatus.find(params[:id])
    authorize(@status)

    @status.update!(status: :read)
    redirect_to(
      user_expectations_path(@user, anchor: "expectation-#{@expectation.id}"),
      notice: 'Expectation status was marked as read'
    )
  end

  def destroy
    @status = ExpectationStatus.find(params[:id])
    authorize(@status)
    if @status.destroy
      flash[:notice] = 'Expectation status removed successfully'
    else
      flash[:alert] = 'Expectation status could not be destroyed'
    end
    redirect_to(user_expectations_path(@user, anchor: "expectation-#{@expectation.id}"))
  end

end
