if ['test'].include? Rails.env
  module ScreenshotTest

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
        image.include_xy?(x,y) && image[x,y] || rgb(0,0,0)
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

        height = images.map {|i| i.height}.max
        width = images.map {|i| i.width}.max
        diff_image = ChunkyPNG::Image.new(width, height)

        height.times do |y|
          width.times do |x|
            pixel_old = get_pixel(images.first,x,y)
            pixel_new = get_pixel(images.last,x,y)

            changed ||=  (pixel_old != pixel_new)

            diff_image[x,y] = rgb(
              r(pixel_old) + r(pixel_new) - 2 * [r(pixel_old), r(pixel_new)].min,
              g(pixel_old) + g(pixel_new) - 2 * [g(pixel_old), g(pixel_new)].min,
              b(pixel_old) + b(pixel_new) - 2 * [b(pixel_old), b(pixel_new)].min
            )
          end
        end

        diff_image.save(diff_file)
        changed
      end

      def force_scroll_bars
        ['y'].each { |dir| @page.execute_script "$('body').css('overflow-#{dir}','scroll');" }
      end

      def take
        force_scroll_bars
        @page.driver.render new_file
      end
    end

    def assume_unchanged_screenshot title
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
