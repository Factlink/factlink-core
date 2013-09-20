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

    def changed?
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

        puts "Pixels changed #{percentage}%  (#{pixels_changed}/#{total_pixels})."
      end

      pixels_changed > 0 || size_changed?
    end

    def take
      sleep 0.5 #wait for page re-render
      @page.driver.save_screenshot new_file, full: true
      @old_image = ChunkyPNG::Image.from_file(old_file)
      @new_image = ChunkyPNG::Image.from_file(new_file)
    end
  end

  def assume_unchanged_screenshot(title)
    shot = Screenshot.new page, title
    shot.take
    if shot.changed?
      if shot.size_changed?
        raise "Screenshot #{title} changed (also size)"
      else
        raise "Screenshot #{title} changed"
      end
    end
  end
end
