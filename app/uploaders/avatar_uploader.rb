class AvatarUploader < ImageUploader
  include CarrierWave::MiniMagick

  version :thumb do
    process :resize_to_fill => [ 200, 200 ]
  end

  def default_url
    "default/#{model.class.name.downcase}_avatar.png"
  end
end