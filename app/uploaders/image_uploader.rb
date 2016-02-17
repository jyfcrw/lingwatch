# encoding: utf-8

class ImageUploader < AttachmentUploader
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
