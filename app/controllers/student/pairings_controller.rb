class Student::PairingsController < ApplicationController

  def index
    pairings = Pairing.for_user(current_user)
    @pending_users = pairings[:pending].index_by(&:id)
    @done_users = pairings[:done].index_by(&:id)
    main_users = (User.for_cohort(@cohort) - [current_user] - @pending_users.values)
    @students = main_users.sort_by{|user| user.full_name }.in_groups_of(6, false)
  end

  def new
    @pairing = Pairing.new(paired_on: Date.current)
    @pair = User.for_cohort(@cohort).find(params[:student_id])
  end

  def create
    @pairing = Pairing.new(params.require(:pairing).permit(:paired_on, :feedback))
    @pair = User.for_cohort(@cohort).find(params[:student_id])
    @pairing.pair = @pair
    @pairing.user = current_user
    if @pairing.save
      redirect_to cohort_pairings_path(@cohort), notice: "Pairing was created successfully!"
    else
      render :new
    end
  end

end
