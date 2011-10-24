require File.expand_path('../../../app/classes/percentage_formatter.rb', __FILE__)

describe PercentageFormatter do
  subject {PercentageFormatter.new(5,15)}

  describe "round_percentages" do
    it {subject.round_percentages([14,16,70]).should == [15,15,70]}
    it {subject.round_percentages([4,4,90]).should == [5,5,90]}
    it {subject.round_percentages([6,6,90]).should == [5,5,90]}
  end
  describe "cap_percentages" do
    it {subject.cap_percentages([15,15,70]).should == [15,15,70]}
    it {subject.cap_percentages([10,10,80]).should == [15,15,70]}
    it {subject.cap_percentages([5,5,90]).should == [15,15,70]}
    it {subject.cap_percentages([4,4,90]).should == [15,15,70]}
    it {subject.cap_percentages([6,6,90]).should == [15,15,70]}
    it {subject.cap_percentages([8,8,84]).should == [15,15,70]}
    #it {subject.cap_percentages([8,46,46]).should == [15,40,45]}
    #it {subject.cap_percentages([13,44,43]).should == [15,45,40]}
    
  end
end