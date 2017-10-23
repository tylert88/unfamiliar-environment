class WriteupMailer < ActionMailer::Base
  default :from => 'fs.all@galvanize.com'

  helper :markdown

  def notification(sender, recipients, writeup, comment, writeup_url)
    @comment = comment
    @writeup_url = writeup_url
    mail(
      :to => recipients.map(&:email),
      :from => sender.email,
      :subject => "[students] Comment added to #{writeup.writeup_topic.subject}"
    )
  end
end
