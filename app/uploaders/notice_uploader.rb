# encoding: utf-8
class NoticeUploader < BaseUploader
  include CarrierWave::MiniMagick

  version :preview do
    process :resize_to_fill => [200, 140]
  end

  version :thumb do
    process :resize_to_fill => [175, 135]
  end

  version :top_index do
    process :resize_to_fill => [456, 495]
  end

  version :index_type_360_230 do
    process :resize_to_fill => [360, 230]
  end

  version :index_type_168_162 do
    process :resize_to_fill => [168, 162]
  end

  version :other_notice do
    process :resize_to_fill => [212, 141]
  end

  version :two_notices_one_column do
    process :resize_to_fill => [262, 235]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
