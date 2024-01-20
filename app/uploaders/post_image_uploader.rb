class PostImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process convert: 'png'
  process tags: ['post_image']

  version :standard do
    process eager: true
    process resize_to_fill: [100, 150, :north]
  end

  version :thumbnail do
    eager
    resize_to_fit(50, 50)
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
