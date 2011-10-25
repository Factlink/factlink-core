class SvgWheelBuilder
  def initialize(
        percentages_colors=['#dbeab3', '#36A9E1', '#E94E1B'],
        percentages_max_colors=['#98d100','#c5eaf8','#f8caba'] #  green blue red
      )
      @percentages_colors = percentages_colors
      @percentages_max_colors = percentages_max_colors
  end
  
  def wheel(percentages)
    RVG::Group.new do |canvas|
      had = 0;
      percentages.each_with_index do |percentage, index|
        if percentage == percentages.max
          stroke = @percentages_max_colors[index]
        else 
          stroke = @percentages_colors[index]
        end
        canvas.path(arc_path(percentage,had,16)).styles(:fill => 'none', :stroke => stroke, :stroke_width => 10)
        had += percentage
      end
    end
  end 

  def string_for_float(f)
    ("%0.5f"%f).sub(/^-(0.0+)$/, '\1')
  end

  def arc_path(percentage, percentage_offset, radius)
    large_angle = percentage > 50

    start_angle = percentage_offset                * 2*Math::PI / 100
    end_angle   = (percentage_offset + percentage) * 2*Math::PI / 100
  
    start_x =   radius * Math.cos(start_angle)
    start_y = - radius * Math.sin(start_angle)
    end_x   =   radius * Math.cos(end_angle)
    end_y   = - radius * Math.sin(end_angle)
    
    path_string(start_x,start_y, end_x, end_y, large_angle, radius)
  end
  
  def path_string(start_x, start_y, end_x, end_y, large_angle, radius)
    start_x = string_for_float(start_x)
    start_y = string_for_float(start_y)
    end_x   = string_for_float(end_x)
    end_y   = string_for_float(end_y)
    
    return [['M',start_x,start_y],
            ["A", radius, radius, 0, large_angle ? 1 : 0,  0, end_x, end_y]].flatten.join(' ')
  end
  
end
