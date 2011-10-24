require 'rvg/rvg'

include Magick
include Math


class WheelController < ApplicationController

  def show
    RVG::dpi = 72
    
    percentages = params[:percentages].split('-').map {|x| x.to_i}
    
    percentages = PercentageFormatter.new(5,15).cap_percentages(percentages)
    
    rvg = RVG.new(2.5.in, 2.5.in).viewbox(0,0,250,250) do |canvas|
        canvas.background_fill = 'white'
        canvas.use(svg_wheel(percentages)).translate(75, 100)
    end
    puts rvg
    local_path = "images/wheel/#{percentages.join('-')}.png"
    filename = Rails.root.join('public', local_path)
    puts filename
    rvg.draw.write(filename)    

    respond_to do |format|
      format.png do
        redirect_to '/' + local_path
      end
    end
  end


  def svg_wheel(percentages, percentages_colors=['green','blue','#e6007e'])
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