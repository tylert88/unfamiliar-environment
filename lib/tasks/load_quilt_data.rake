namespace :db do
  namespace :seed do

    desc 'Update users in the database with their quilt IDs'
    task load_quilt_data: :environment do
      CSV.foreach(File.join(Rails.root, 'db', 'seeds', 'users_with_headers.csv')) do |row|
        if row[3] == 't'
          user = User.where(email: row[1]).first
          if user
            user.update_attribute(:galvanize_id, row[0])
          end
        end
      end
    end
  end
end
