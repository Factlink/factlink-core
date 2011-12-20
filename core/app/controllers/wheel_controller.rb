require 'rvg/rvg'

include Magick
include Math


class WheelController < ApplicationController

  def show
    
    percentages = params[:percentages].split('-').map {|x| x.to_i}
    
    after_percentages = PercentageFormatter.new(5,15).process_percentages(percentages)

    local_path = "images/wheel/#{after_percentages.join('-')}.png"

    respond_to do |format|
      format.png do
        if after_percentages != percentages
          this_url_path = "images/wheel/#{percentages.join('-')}.png"
          redir_to_file = "#{after_percentages.join('-')}.png"
          redir_to_path = "images/wheel/#{redir_to_file}"

          # only make a symlink if the file already exists to prevent concurrent requests on the same url from failing
          if File.exists?(Rails.root.join('public',redir_to_path))
            File.symlink(redir_to_file, Rails.root.join('public',this_url_path))
          end
          
          # maybe this image already exists, redirect first
        else
          #since this controller was called, the image does not exist yet
          rvg = RVG.new(20,20).viewbox(0,0,20,20) do |canvas|
              canvas.use(SvgWheelBuilder.new().wheel(after_percentages)).translate(10,10)
              
          end
          filename = Rails.root.join('app','assets', local_path)
          rvg.draw.write(filename)    
        end
        redirect_to '/' + local_path
      end
    end
  end


  
end
