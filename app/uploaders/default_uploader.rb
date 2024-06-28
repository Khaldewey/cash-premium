class DefaultUploader < BaseUploader
  include CarrierWave::MiniMagick

  storage :file # Configuração para armazenamento local
  

  def store_dir
    '/public/uploads'
  end


  version :preview do
    process :resize_to_fill => [200, 140]
  end

  version :thumb do
    process :resize_to_fill => [175, 135]
  end

  version :map do
    process :resize_to_fill => [590, 270]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end