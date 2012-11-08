require File.expand_path('../../../app/classes/svg_wheel_builder.rb', __FILE__)

describe SvgWheelBuilder do

  describe "#string_for_float" do
    it {subject.string_for_float(0.0).should =="0.00000"}
    it {subject.string_for_float(-0.0000000000001).should =="0.00000"}
  end
  
end