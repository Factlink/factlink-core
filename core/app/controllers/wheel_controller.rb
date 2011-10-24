require 'rvg/rvg'

include Magick
include Math


class WheelController < ApplicationController

  def show
    RVG::dpi = 72
    
    percentages = params[:percentages].split('-').map {|x| x.to_i}
    
    percentages = round_percentages(percentages)
    percentages = cap_percentages(percentages)
    
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

  def scale_percentages(percentages,round_to=5)
    scale_to=100/round_to
    total = percentages.reduce(0,:+)
    percentages.map {|x| (x * scale_to/total).round.to_i * 100/scale_to })
  end

  def cap_percentages(percentages,minimum=15, round_to=5)
    total = percentages.reduce(0,:+)
    after_total, large_ones = 0, 0
    percentages.each do |percentage|
      after_total += [percentage, minimum].max
      if percentage > (100 - minimum)/2
        large_ones += percentage 
      end
    end
    too_much = after_total - 100
    return percentages.map do |percentage|
      if percentage < minimum
        percentage = minimum
      elsif percentage > (100-minimum)/2
        percentage = percentage - percentage.div(large_ones*round_to)*too_much*round_to
      end
      percentage
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