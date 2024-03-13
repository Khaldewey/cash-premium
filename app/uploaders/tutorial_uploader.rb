# encoding: utf-8
class TutorialUploader < BaseUploader
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(pdf doc docx xlsx csv)
  end
end
