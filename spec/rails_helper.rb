# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/mocks'
require 'capybara/rspec'
require 'vcr'
require "pundit/rspec"

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.filter_sensitive_data('<PIVOTAL TRACKER TOKEN>') { ENV['PIVOTAL_TRACKER_TOKEN'].to_s }
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Rails.application.config.snippet_app_auth_token = 'abc123'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true

  config.include OmniauthHelpers
  config.include ObjectFactories
  config.include ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.extend FeatureHelpers, type: :feature

  Fog.mock!
  connection = Fog::Storage.new(
    :provider => "AWS",
    :aws_access_key_id      => "aws_access_key_id",
    :aws_secret_access_key  => "aws_secret_access_key",
  )

  connection.directories.create(:key => 'students-gschool-test')
end

OmniAuth.config.test_mode = true
