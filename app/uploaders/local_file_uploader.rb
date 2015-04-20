# encoding: utf-8

class LocalFileUploader < CarrierWave::Uploader::Base



  # Choose what kind of storage to use for this uploader:
  storage :file

  def store_dir
    "../usercontent"
  end

  def filename
    "#{SecureRandom.uuid}" if original_filename.present?
  end


end
