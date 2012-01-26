
require_relative '../ohm_helper.rb'
require_relative '../../app/ohm-models/authority.rb'

class Item < OurOhm
  attribute :number
end



describe Authority do
  let(:i1) { Item.create }

  before do
    Authority.reset_calculators
  end

  describe :to_f do
    it "should return a float" do
      Authority.new.to_f.should be_a(Float)
    end
    context "initially" do
      its(:to_f) { should == 1 }
    end
  end

  describe :to_s do
    it "should return a rounded authority" do
      Authority.new(authority: 2.3).to_s.should == "2.3"
    end
    it "should return a rounded authority" do
      Authority.new(authority: 7.242416).to_s.should == "7.2"
    end
  end

  describe ".from" do
    context "for an undefined authority" do
      it do
        Authority.from(Item.create).to_f.should == 1
      end
    end
    context "for a defined authority" do
      it do
        a = Authority.create subject: i1, authority: 15.6
        Authority.from(i1).should == a
      end
    end
    it "should return an authority for the subject" do
      Authority.from(i1).subject.should == i1
    end
  end
  describe ".set_from" do
    it "should set the authority" do
      Authority.set_from(i1, 21)
      Authority.from(i1).to_f.should == 21
    end
    it "should update the authority" do
      Authority.set_from(i1, 23)
      Authority.set_from(i1, 21)
      Authority.from(i1).to_f.should == 21
    end
  end
  describe ".calculated_from_authority" do
    it "should use the calculate from calculate_from" do
      Authority.calculate_from Item do |i|
        i.number
      end
      i1.number = 10
      Authority.calculated_from_authority(i1).should == 10
    end
    context "when calculate_from is provided with a symbol" do
      it "should use the calculate from calculate_from" do
        Authority.calculate_from :Item do |i|
          i.number
        end
        i1.number = 10
        Authority.calculated_from_authority(i1).should == 10
      end
    end
    it "should return 1.0 when no calculator is defined" do
      Authority.calculated_from_authority(i1).should == 1
    end
  end
  describe ".reset_calculators" do
    it "should remove all calculators" do
      Authority.calculate_from Item do |i|
        i.number
      end
      Authority.reset_calculators.length.should == 0
      Authority.send(:calculators).length.should == 0
    end
  end
  describe ".recalculate_from" do
    pending "should use the calculate from caclculate_from" do
      Authority.calculate_from Item do |i|
        i.number
      end
      i1.number = 10
      Authority.recalculate_from i1
      Authority.from(i1).to_f.should == 10
    end
  end
end
