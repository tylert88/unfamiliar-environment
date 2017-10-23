class Instructor::WriteupTopicsController < InstructorRequiredController

  def index
    @writeup_topics = @cohort.writeup_topics.order("updated_at desc")
  end

  def new
    @writeup_topic = @cohort.writeup_topics.new
  end

  def show
    @writeup_topic = @cohort.
      writeup_topics.
      includes(writeups: {comments: :user}).
      find(params[:id])
    @students_who_did_not_complete = @writeup_topic.students_who_did_not_complete
  end

  def create
    @writeup_topic = @cohort.writeup_topics.new(writeup_topic_params)

    if @writeup_topic.save
      redirect_to(
        instructor_cohort_writeup_topics_path(@cohort),
        notice: 'Writeup Topic created successfully'
      )
    else
      render :new
    end
  end

  def edit
    @writeup_topic = @cohort.writeup_topics.find(params[:id])
  end

  def update
    @writeup_topic = @cohort.writeup_topics.find(params[:id])

    if @writeup_topic.update(writeup_topic_params)
      redirect_to(
        instructor_cohort_writeup_topics_path(@cohort),
        notice: 'Writeup Topic updated successfully'
      )
    else
      render :edit
    end
  end

  def destroy
    @writeup_topic = @cohort.writeup_topics.find_by(id: params[:id]).try(:destroy)
    redirect_to(
      instructor_cohort_writeup_topics_path,
      notice: "Writeup Topic was deleted successfully"
    )
  end

  private

  def writeup_topic_params
    params.require(:writeup_topic).permit(:subject, :description, :active)
  end

end
