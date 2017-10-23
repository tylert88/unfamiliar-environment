class WriteupCommentsController < ApplicationController

  def create
    writeup = Writeup.includes(comments: :user).find(params[:writeup_id])
    comment = writeup.comments.new(params.require(:writeup_comment).permit(:body))
    comment.user = current_user
    authorize(comment)
    if comment.save
      if current_user.instructor?
        recipients = [writeup.user]
        redirect_url = instructor_cohort_writeup_topic_url(writeup.writeup_topic.cohort, writeup.writeup_topic)
      else
        recipients = writeup.writeup_topic.cohort.staffings.map(&:user)
        redirect_url = cohort_writeups_url(writeup.writeup_topic.cohort)
      end
      if recipients.present?
        WriteupMailer.notification(current_user, recipients, writeup, comment, redirect_url).deliver
      end
    end
    render partial: 'writeup_comments/section', locals: {writeup: writeup}
  end

end
