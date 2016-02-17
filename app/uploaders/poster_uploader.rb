class PosterUploader < ImageUploader
  include CarrierWave::MiniMagick

  version :thumb do
    process :resize_to_fill => [ 600, 400 ]
  end

  version :small_thumb, from_version: :thumb do
    process :resize_to_fill => [ 300, 200 ]
  end

  def default_url
    "default/#{version_name.to_s}_#{model.class.name.downcase}.png"
  end
end
