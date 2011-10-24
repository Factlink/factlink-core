require 'rvg/rvg'

include Magick
include Math


class WheelController < ApplicationController

  def show
    RVG::dpi = 72
    
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
          rvg = RVG.new(2.5.in, 2.5.in).viewbox(0,0,250,250) do |canvas|
              canvas.use(svg_wheel(after_percentages)).translate(75, 100)
          end
          filename = Rails.root.join('public', local_path)
          rvg.draw.write(filename)    
        end
        redirect_to '/' + local_path
      end
    end
  end


  def svg_wheel(percentages, percentages_colors=['green','blue','red'])
    RVG::Group.new do |canvas|
      had = 0;
      percentages.each_with_index do |percentage, index|
        canvas.path(arc_path(percentage,had,30)).styles(:fill => 'none', :stroke => percentages_colors[index], :stroke_width => 4)
        had += percentage
      end
    end
  end 

  def string_for_float(f)
    s = "%0.5f"%f
    s.sub!(/^-(0.0+)$/, '\1')
    s
  end

  def arc_path(percentage, percentage_offset, radius)
    percentage = percentage - 2 ; # add padding after arc

    large_angle = percentage > 50

    start_angle = percentage_offset         * 2*Math::PI / 100
    end_angle = (percentage_offset + percentage) * 2*Math::PI / 100
  
    start_x = radius * Math.cos(start_angle)
    start_y = - radius * Math.sin(start_angle)
    end_x   = radius * Math.cos(end_angle)
    end_y   = - radius * Math.sin(end_angle)
    
    path_string(start_x,start_y, end_x, end_y, large_angle, radius)
  end
  
  def path_string(start_x, start_y, end_x, end_y, large_angle, radius)
    start_x = string_for_float(start_x)
    start_y = string_for_float(start_y)
    end_x   = string_for_float(end_x)
    end_y   = string_for_float(end_y)
    
    path = "M#{start_x},#{start_y}" +
           "A#{radius},#{radius},0,#{large_angle ? 1 : 0 },0,#{end_x},#{end_y}"
    puts path
    return path
  end
  
end