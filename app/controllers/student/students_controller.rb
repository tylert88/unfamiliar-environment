class Student::StudentsController < ApplicationController

  def index
    @students = User.for_cohort(@cohort)
  end

  def show
    @student = User.find(params[:id])
  end

  def edit
    @student = User.find(params[:id])
  end

end
