class StudentsController < ApplicationController

  skip_before_action :require_signed_in_user

  layout 'public'

  def show
    @student = User.find(params[:id])
  end
end
