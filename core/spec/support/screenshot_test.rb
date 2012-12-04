module ScreenshotTest
  module OS
    def OS.osx?
      #TODO This doesn't work if we switch to JRuby
      (/darwin/ =~ RUBY_PLATFORM) != nil
    end
  end

  class Screenshot
    include ChunkyPNG::Color
    def initialize page, title
      @title = title
      @page = page
    end

    def old_file
      Rails.root.join('spec','integration','screenshots',"#{@title}.png")
    end

    def new_file
      Rails.root.join "#{Capybara.save_and_open_page_path}" "screenshot-#{@title}-new.png"
    end

    def diff_file
      Rails.root.join "#{Capybara.save_and_open_page_path}" "screenshot-#{@title}-diff.png"
    end

    def get_pixel(image, x, y)
      image.get_pixel(x,y) || rgb(0,0,0)
    end

    def images
      @images ||= [
        ChunkyPNG::Image.from_file(old_file),
        ChunkyPNG::Image.from_file(new_file)
      ]
    end

    def size_changed?
      (images.first.height != images.last.height) || (images.first.width != images.last.width)
    end

    def changed?
      changed = false
      pixels_changed = 0

      height = images.map {|i| i.height}.max
      width = images.map {|i| i.width}.max
      diff_image = ChunkyPNG::Image.new(width, height)

      height.times do |y|
        width.times do |x|
          pixel_old = get_pixel(images.first,x,y)
          pixel_new = get_pixel(images.last,x,y)

          changed ||=  (pixel_old != pixel_new)

          if changed
            pixels_changed += 1

            red_delta = [r(pixel_old), r(pixel_new)].max - [r(pixel_old), r(pixel_new)].min
            green_delta = [g(pixel_old), g(pixel_new)].max - [g(pixel_old), g(pixel_new)].min
            blue_delta = [b(pixel_old), b(pixel_new)].max - [b(pixel_old), b(pixel_new)].min

            changed_amount += red_delta + green_delta + blue_delta

            # give changed pixel a red color with a value of red between 125 and 254
            # indication how much has changed
            delta = ((red_delta + green_delta + blue_delta)/6) + 124
            diff_image[x,y] = rgb(delta,0,0)
          else
            # fading out the pixel by reducing the distance to white by two thirds
            grey_scale = 255-((255 - ((b(pixel_old)+g(pixel_old)+b(pixel_old))/3))/3)

            diff_image[x,y] = rgb(grey_scale, grey_scale, grey_scale)
          end
        end
      end

      if changed
        diff_image.save(diff_file)
        puts "Pixels changed #{pixels_changed}."
      end

      changed
    end

    def force_scroll_bars
      ['y'].each { |dir| @page.execute_script "$('body').css('overflow-#{dir}','scroll');" }
    end

    def take
      force_scroll_bars
      # Need this to let the animations settle.
      sleep 1
      @page.driver.render new_file
    end
  end

  def assume_unchanged_screenshot title
    if OS.osx?
      pending "Screenshots don't work locally."
    else
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
end
