class StudentMailer < ActionMailer::Base
  default :from => 'fs.all@galvanize.com'

  helper :markdown

  def invitation(user, invitation_type = nil)
    @user = user
    @invitation_type = invitation_type
    @verifier = Rails.application.message_verifier('set_password').generate(@user.id)
    mail(:to => user.email, :subject => I18n.t('student_mailer.invitation.subject'))
  end

  def one_on_one(sender, student, instructor, time, date)
    @student = student
    @instructor = instructor
    @time = time
    @date = date
    mail(
      :from => sender.email,
      :to => @student.email,
      :subject => "Your one-on-one time for #{@date.strftime("%-m/%-d/%Y")}"
    )
  end

  def action_plan_entry(creator, entry)
    @entry = entry
    mail(
      from: creator.email,
      bcc: entry.cohort.instructors.map(&:email) - [creator.email],
      to: entry.user.email,
      subject: "Galvanize Action Plan: #{entry.created_at.strftime('%-m/%-d/%Y')}"
    )
  end
end
