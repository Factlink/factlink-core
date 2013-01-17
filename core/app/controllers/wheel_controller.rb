require 'rvg/rvg'

include Magick
include Math

class WheelController < ApplicationController

  def show
    if /\A([0-9]+)-([0-9]+)-([0-9]+)\Z/.match(params[:percentages])
      percentages = [$1.to_i,$2.to_i,$3.to_i]
    else
      raise_404
    end

    after_percentages = PercentageFormatter.new(5,15).process_percentages(percentages)

    local_path = "system/wheel/#{after_percentages.join('-')}.png"

    respond_to do |format|
      format.png do
        if after_percentages != percentages
          this_url_path = "system/wheel/#{percentages.join('-')}.png"
          redir_to_file = "#{after_percentages.join('-')}.png"
          redir_to_path = "system/wheel/#{redir_to_file}"

          # only make a symlink if the file already exists to prevent concurrent requests on the same url from failing
          if File.exists?(Rails.root.join('public', redir_to_path))
            File.symlink(redir_to_file, Rails.root.join('public', this_url_path))
          end

          # maybe this image already exists, redirect first
        else
          #since this controller was called, the image does not exist yet
          rvg = RVG.new(20,20).viewbox(0,0,20,20) do |canvas|
              canvas.use(SvgWheelBuilder.new().wheel(after_percentages)).translate(10,10)
          end
          filename = Rails.root.join('public', local_path)
          rvg.draw.write(filename)
        end
        redirect_to '/' + local_path
      end
    end
  end
end
