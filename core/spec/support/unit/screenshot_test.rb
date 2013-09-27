module ScreenshotTest
  class Screenshot
    include ChunkyPNG::Color

    def initialize(page, title)
      @title = title
      @page = page
    end

    def old_file
      Rails.root.join('spec','screenshots','screenshots',"#{@title}.png")
    end

    def new_file
      Rails.root.join "#{Capybara.save_and_open_page_path}" "/#{@title}.png"
    end

    def diff_file
      Rails.root.join "#{Capybara.save_and_open_page_path}" "/#{@title}-diff.png"
    end

    def size_changed?
      (@old_image.height - @new_image.height).abs > 3 || (@old_image.width - @new_image.width).abs > 3
    end

    def exact_changed?
      pixels_changed = 0
      width = [@old_image.width, @new_image.width].min
      height = [@old_image.height, @new_image.height].min

      diff_image = ChunkyPNG::Image.new(width, height)
      y=0
      while y < height
        x=0
        while x < width
          pixel_old = @old_image.get_pixel(x,y)
          pixel_new = @new_image.get_pixel(x,y)

          if pixel_old != pixel_new
            pixels_changed += 1

            red_delta = (r(pixel_old) - r(pixel_new)).abs
            green_delta = (g(pixel_old) - g(pixel_new)).abs
            blue_delta = (b(pixel_old) - b(pixel_new)).abs

            changed_amount = red_delta + green_delta + blue_delta

            # give changed pixel a red color with a value of red between 125 and 254
            # indication how much has changed
            delta = changed_amount/6 + 128
            diff_image[x,y] = rgb(delta,0,0)
          else
            # fading out the pixel by reducing the distance to white by two thirds
            grey_scale = 255*2/3 + (b(pixel_old)+g(pixel_old)+r(pixel_old))/9

            diff_image[x,y] = rgb(grey_scale, grey_scale, grey_scale)
          end
          x += 1
        end
        y += 1
      end

      if pixels_changed > 0
        diff_image.save(diff_file)
        total_pixels = width * height
        percentage = 100.0 * pixels_changed / total_pixels
        puts ""
        puts "Pixels changed #{percentage}%  (#{pixels_changed}/#{total_pixels})."
      end

      pixels_changed > 0 || size_changed?
    end


    # Compares old and new screenshot, returning true when the images differ
    # significantly. The aim to to ignore changes solely due to font-rendering
    # differences such as antialiasing and vertical glyph offsetting since
    # these are different in different OS's.
    #
    # Pixels within distance 2 of the image edge are ignored; size differences
    # ignored if any dimension change is less than 3; when the size has changed,
    # the images are aligned by their top-left corner.
    #
    # Output: a diff image on disk with the blue channel representing input
    # edges, the red channel representing input differences, and the green
    # channel being either black (insignificant change) or fully green
    # (significant change).  Prints some statistics to stdout.
    #
    # Algorithm: ignore pixel-wise differences below a threshold determined by
    # local contrast and local contrast difference.  In effect, small changes
    # near high-contrast areas (such as anti-aliased pixels on a font-glyph
    # boundary) are irrelevant.   The local-contrast-difference check ensures
    # that large differences in edges themselves are detected (e.g. different
    # glyphs in new and old screenshots).
    #
    # Pseudocode:
    # - X-edge detect by comparing each pixel with its right neighbor
    # - Also do this for Y-edges using the bottom neighbor
    # - ...and do this for new and old screenshots
    # - accumulate these edge-detect images so we can efficiently compute
    #   the averge edge-density in any image rectangle
    # - Compare both images pixel-by-pixel,
    #    - Per pixel badness consists of weighted sum of:
    #       - color-difference (simplistic perceptual metric)
    #       - difference in X-edge-density in a surrounding rectangle
    #       - difference in Y-edge-density in a surrounding rectangle
    #    - Per pixel theshold consists of a weighted sum of:
    #       - The local contrast (X+Y edge density) of the old image
    #       - The local contrast of the new image
    #       - a positive bias
    #    - Render some per-pixel stats into an image-diff for later inspection.
    # - The image is changed iff any pixel's badness exceeds its threshold
    def fuzzy_changed?
      pixels_changed_count = 0
      total_badness = 0.0
      total_lc = 0.0
      max_local_contrast = 0

      diff_gray = GrayscaleImage.rgb_delta28_image(@old_image, @new_image)
      width, height = diff_gray.width, diff_gray.height

      cx1 = GrayscaleImage.rgb_delta28_contrast_image_x(@old_image)
      cx1acc = cx1.accumulated_image
      cy1 = GrayscaleImage.rgb_delta28_contrast_image_y(@old_image)
      cy1acc = cy1.accumulated_image

      cx2 = GrayscaleImage.rgb_delta28_contrast_image_x(@new_image)
      cx2acc = cx2.accumulated_image
      cy2 = GrayscaleImage.rgb_delta28_contrast_image_y(@new_image)
      cy2acc = cy2.accumulated_image

      cx_acc = cx1acc + cx2acc #upto 56*255 per pixel
      cy_acc = cy1acc + cy2acc
      color_diff_img = ChunkyPNG::Image.new(width, height)

      y = 2
      while y < height - 2
        x = 2
        while x < width - 2
          changed_amount = diff_gray[x, y] #upto 28*255

          scaled_changed_amount = (changed_amount + 27)/28

          # compare contrasts in a 4x5 region.  Note that to be centered on the current pixel,
          # you need to correct for the fact that the x-contrast is a half-pixel shifted
          # and that the accumulation buffer is upto and EXCLUDING the current pixel.
          local_cx1 = cx1acc[x-1, y-2] + cx1acc[x+3, y+3] - (cx1acc[x-1, y+3] + cx1acc[x+3, y-2]) #upto 560*255
          local_cy1 = cy1acc[x-2, y-1] + cy1acc[x+3, y+3] - (cy1acc[x+3, y-1] + cy1acc[x-2, y+3]) #upto 560*255

          local_cx2 = cx2acc[x-1, y-2] + cx2acc[x+3, y+3] - (cx2acc[x-1, y+3] + cx2acc[x+3, y-2]) #upto 560*255
          local_cy2 = cy2acc[x-2, y-1] + cy2acc[x+3, y+3] - (cy2acc[x+3, y-1] + cy2acc[x-2, y+3]) #upto 560*255

          contrast_badness = (local_cx1 - local_cx2).abs + (local_cy1 - local_cy2).abs #upto 1120*255

          local_cx = cx_acc[x+0, y-1] + cx_acc[x+2, y+2] - (cx_acc[x+0, y+2] + cx_acc[x+2, y-1]) #upto 336*255
          local_cy = cy_acc[x-1, y+0] + cy_acc[x+2, y+2] - (cy_acc[x+2, y+0] + cy_acc[x-1, y+2]) #upto 336*255
          local_contrast = local_cx + local_cy   #upto 672*255

          max_local_contrast = [local_contrast, max_local_contrast].max
          local_contrast_scaled =  (Math.sqrt(Math.sqrt(Math.sqrt(local_contrast / (672.0*255.0+0.01)))) * 256.0).round  #upto 255
          total_badness += changed_amount * 24.0 / (local_contrast + 2550.0) +
                           contrast_badness / 13600

          err = 0
          total_lc += local_contrast
          if 40*changed_amount + contrast_badness > 20*local_contrast + 47600
            pixels_changed_count += 1
            err = 255
          end
          color_diff_img[x,y] = rgb(scaled_changed_amount, err, local_contrast_scaled)
          x += 1
        end
        y += 1
      end

      color_diff_img.save(diff_file)
      puts ""
      if pixels_changed_count > 0
        total_pixels = width * height
        percentage = 100.0 * pixels_changed_count / total_pixels

        puts "Pixels changed #{percentage}%  (#{pixels_changed_count}/#{total_pixels})."
      end

      puts "Per-pixel badness (#{@title}): #{total_badness/((width-2)*(height-2))*100}"
      puts "Per-pixel contrast: #{total_lc/((width-4)*(height-4))} (max: #{max_local_contrast})"
      pixels_changed_count > 0 || size_changed?
    end

    def take
      sleep 0.5 #wait for page re-render
      @page.driver.save_screenshot new_file, full: true
      @old_image = ChunkyPNG::Image.from_file(old_file)
      @new_image = ChunkyPNG::Image.from_file(new_file)
    end

    def changed?
      ENV["FUZZY_IMAGE_DIFF"] ? fuzzy_changed? : exact_changed?
    end
  end

  def assume_unchanged_screenshot(title)
    shot = Screenshot.new page, title
    shot.take
    t0 = Time.now
    begin
      if shot.changed?
        if shot.size_changed?
          raise "Screenshot #{title} changed (also size)"
        else
          raise "Screenshot #{title} changed"
        end
      end
    ensure
      t1 = Time.now
      puts "Screenshot processing took #{t1-t0}s"
    end
  end
end
