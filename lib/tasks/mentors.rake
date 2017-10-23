namespace :mentors do

  task :import => :environment do
    Mentorship.all.each do |mentor|
      user = User.where('lower(email) = ?', mentor.email.downcase).first
      if user
        puts "Assigning #{mentor.first_name} #{mentor.last_name}..."
      else
        puts "Creating  #{mentor.first_name} #{mentor.last_name}..."
        user = User.create!(
          email: mentor.email.downcase,
          first_name: mentor.first_name,
          last_name: mentor.last_name,
        )
      end
      mentor.update!(mentor: user)
    end
  end

end
