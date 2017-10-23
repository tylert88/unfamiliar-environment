class InstructorMailer < ActionMailer::Base
  default :from => 'fs.all@galvanize.com'

  helper :markdown

  def one_on_one_schedule(instructor, appointments)
    @instructor, @appointments = instructor, appointments
    mail(:to => instructor.email, :subject => "Your one-on-one time for #{Date.current.strftime("%-m/%-d/%Y")}")
  end
end
