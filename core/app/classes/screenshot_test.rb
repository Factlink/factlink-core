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

      def changed?
        images = [
          ChunkyPNG::Image.from_file(old_file),
          ChunkyPNG::Image.from_file(new_file)
        ]

        changed = false

        images.first.height.times do |y|
          images.first.row(y).each_with_index do |pixel, x|
            changed ||= images.last[x,y] != pixel
            images.last[x,y] = rgb(
              r(pixel) + r(images.last[x,y]) - 2 * [r(pixel), r(images.last[x,y])].min,
              g(pixel) + g(images.last[x,y]) - 2 * [g(pixel), g(images.last[x,y])].min,
              b(pixel) + b(images.last[x,y]) - 2 * [b(pixel), b(images.last[x,y])].min
            )
          end
        end

        images.last.save(diff_file)
        changed
      end

      def take
        @page.driver.render new_file
      end
    end

    def assume_unchanged_screenshot title
      shot = Screenshot.new page, title
      shot.take
      if shot.changed?
        raise "Screenshot #{title} changed"
      end
    end



  end
end