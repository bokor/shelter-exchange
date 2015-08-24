module CarrierWave
  module MiniMagick

    # Rotates the image based on the EXIF Orientation. Fixes an issue
    # with the iphone and how it stores orientation details.  We want to use
    # the EXIF orientation instead.
    def fix_exif_orientation
      manipulate! do |img|
        img.auto_orient
        img = yield(img) if block_given?
        img
      end
    end
  end
end

