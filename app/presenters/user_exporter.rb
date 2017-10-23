require 'csv'

class UserExporter

  def initialize(users)
    @users = users
  end

  def to_csv(view_context)
    fields = {
      "ID" => :id,
      "Cohort" => ->(user, _){ user.enrollments.map(&:cohort).map(&:name).join(", ") },
      "Status" => ->(user, _){ user.enrollments.map(&:status).join(", ") },
      "First Name" => :first_name,
      "Last Name" => :last_name,
      "Email" => :email,
      "Github" => :github_username,
      "Role" => :role,
      "Phone" => :phone,
      "Address 1" => :address_1,
      "Address 2" => :address_2,
      "City" => :city,
      "State" => :state,
      "Zip" => :zip_code,
      "Twitter" => :twitter,
      "Blog" => :blog,
      "LinkedIn" => :linkedin,
      "Avatar" => ->(user, view_context){ user.avatar.url },
      "Shirt Size" => :shirt_size,
      "Internal URL" => ->(user, view_context){ view_context.user_url(user) },
      "External URL" => ->(user, view_context){ view_context.public_student_url(user) },
    }

    CSV.generate do |csv|
      csv << fields.keys
      @users.each do |user|
        csv << fields.values.map do |value|
          if value.respond_to?(:call)
            value.call(user, view_context)
          else
            user.send(value)
          end
        end
      end
    end
  end

end
