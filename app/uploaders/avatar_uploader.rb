class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :card do
    process :resize_to_fill => [300, 200]
  end

  version :hero do
    process :build_hero
  end

  def build_hero
    manipulate! :format => 'png' do |img|
      img.crop_resized!(1440, 500, ::Magick::CenterGravity)
      img.opacity = ::Magick::MaxRGB/2
      img.blur_image(0, 50)
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
