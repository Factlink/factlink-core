module OS
  def OS.osx?
    #This doesn't work if we switch to JRuby
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end
end

module ScreenshotTest
  class Screenshot
    include ChunkyPNG::Color
    include FileUtils

    def initialize page, title
      @title = title
      @page = page
    end

    def take
      force_scroll_bars
      sleep 1
      @page.driver.render current_image_path
    end

    def changed?
      if not File.exists? previous_image_path
        update_old_file
        raise 'There is no previous screenshot on this non osx machine, run again if this is the first time your building this branch.'
      end
      previous_image = load_image(previous_image_path)
      current_image = load_image(current_image_path)

      diff_image = difference_between_files previous_image, current_image

      if diff_image
        diff_image.save(diff_file)
      end

      diff_image
    end

    def update_old_file
      copy_file(current_image_path, previous_image_path)
    end

    def changed_osx?
      if not File.exists? previous_osx_image_path
        update_previous_osx_screenshot
      end
      previous_osx_image = ChunkyPNG::Image.from_file(previous_osx_image_path)
      current_osx_image = ChunkyPNG::Image.from_file(current_osx_image_path)

      difference_between_files previous_osx_image, current_osx_image
    end

    def update_previous_osx_screenshot
      copy_file(current_osx_image_path, previous_osx_image_path)
    end

    private
      def creating_workspace_image_path name
        Rails.root.join "#{Capybara.save_and_open_page_path}" "screenshot-#{name}.png"
      end

      def previous_osx_image_path
        creating_workspace_image_path "#{@title}-previous-osx"
      end

      def current_image_path
        creating_workspace_image_path "#{@title}-new"
      end

      def diff_file
        creating_workspace_image_path "#{@title}-diff"
      end

      def current_osx_image_path
        Rails.root.join('spec', 'integration', 'screenshots', "#{@title}.png")
      end

      def previous_image_path
        if OS.osx?
          current_osx_image_path
        else
          creating_workspace_image_path "#{@title}-old"
        end
      end

      def load_image path
        ChunkyPNG::Image.from_file path
      end

      def get_pixel(image, x, y)
        image.get_pixel(x,y) || rgb(0,0,0)
      end

      def difference_between_files old_image, new_image
        changed = false
        pixels_changed = 0
        changed_amount = 0

        height = [old_image.height, new_image.height].max
        width = [old_image.width, new_image.width].max
        diff_image = ChunkyPNG::Image.new(width, height)

        height.times do |y|
          width.times do |x|
            pixel_old = get_pixel(old_image, x, y)
            pixel_new = get_pixel(new_image, x, y)

            if pixel_old != pixel_new
              changed = true
              pixels_changed += 1

              changed_amount += [r(pixel_old), r(pixel_new)].max - [r(pixel_old), r(pixel_new)].min
              changed_amount += [g(pixel_old), g(pixel_new)].max - [g(pixel_old), g(pixel_new)].min
              changed_amount += [b(pixel_old), b(pixel_new)].max - [b(pixel_old), b(pixel_new)].min

              diff_image[x,y] = rgb(254,254,254)
            else
              diff_image[x,y] = rgb(0,0,0)
            end
          end
        end

        if changed
          puts "Total color changed: #{changed_amount}"
          puts "Pixels changed #{pixels_changed}"
          return diff_image
        end

        false
      end

      def force_scroll_bars
        ['y'].each { |dir| @page.execute_script "$('body').css('overflow-#{dir}','scroll');" }
      end
  end

  def assume_unchanged_screenshot title
    shot = Screenshot.new page, title
    shot.take
    if shot.changed?
      if not OS.osx? and shot.changed_osx?
        # Update the local screenshot, because the osx screenshot has changed.
        shot.update_old_file
      else
        raise "Screenshot #{title} changed"
      end
      if not Os.osx?
        shot.update_previous_osx_screenshot
      end
    else
      if shot.changed_osx?
        raise "Screenshot in Git changed but the local screenshot hasn't."
      end
    end
  end
end
