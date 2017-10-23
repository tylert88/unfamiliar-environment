CarrierWave.configure do |config|
  if Rails.env.development?
    config.storage = :file
  elsif Rails.env.test?
    config.enable_processing = false
    config.storage = :fog
    config.fog_credentials = {
      :provider               => "AWS",
      :aws_access_key_id      => "aws_access_key_id",
      :aws_secret_access_key  => "aws_secret_access_key",
    }
    config.fog_directory  = "students-gschool-#{Rails.env}"
  else
    config.storage = :fog
    config.fog_credentials = {
      :provider               => "AWS",
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    }
    config.fog_directory  = "students-gschool-#{Rails.env}"
  end
end
