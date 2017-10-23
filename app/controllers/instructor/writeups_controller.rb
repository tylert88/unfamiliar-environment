class Instructor::WriteupsController < InstructorRequiredController

  def update
    @writeup_topic = @cohort.writeup_topics.find(params[:writeup_topic_id])
    @writeup = @writeup_topic.writeups.find(params[:id])
    @writeup.update(params.require(:writeup).permit(:score))
    render nothing: true
  end

  private

  def writeup_topic_params
    params.require(:writeup_topic).permit(:subject, :description, :active)
  end

end
