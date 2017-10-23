class Student::WriteupsController < ApplicationController

  before_action except: :index do
    @writeup_topic = WriteupTopic.where(cohort_id: params[:cohort_id]).find(params[:writeup_topic_id])
  end

  def index
    @writeups = Writeup.where(user_id: current_user).
      order('created_at desc').
      includes(:writeup_topic, comments: :user)

    @pending_topics = @cohort.writeup_topics.active - @writeups.map(&:writeup_topic)
  end

  def new
    @writeup = @writeup_topic.writeups.new(writeup_topic_id: params[:writeup_topic_id])
  end

  def create
    @writeup = @writeup_topic.writeups.new(writeup_params)
    @writeup.user = current_user

    if @writeup.save
      redirect_to(
        cohort_writeups_path(@cohort),
        :notice => "Your writeup was submitted"
      )
    else
      render :new
    end
  end

  def edit
    @writeup = @writeup_topic.writeups.
      where(user_id: current_user).
      find(params[:id])
  end

  def update
    @writeup = @writeup_topic.writeups.
      where(user_id: current_user).
      find(params[:id])

    if @writeup.update(writeup_params)
      redirect_to(
        cohort_writeups_path(@cohort),
        :notice => "Your writeup was submitted"
      )
    else
      render :edit
    end
  end

  def destroy
    @writeup = @writeup_topic.writeups.
      where(user_id: current_user).
      find(params[:id])
    @writeup.destroy
    redirect_to cohort_writeups_path(@cohort)
  end

  private

  def writeup_params
    params.require(:writeup).permit(:response)
  end
end
