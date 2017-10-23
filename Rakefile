# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Students::Application.load_tasks

# fix error with structure dump on heroku
Rake::Task["db:structure:dump"].clear if Rails.env.production?
