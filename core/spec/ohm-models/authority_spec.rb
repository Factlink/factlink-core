
require_relative '../ohm_helper.rb'
require_relative '../../app/ohm-models/authority.rb'

class Item < OurOhm;end


describe Authority do

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
        @i = Item.create
        @a = Authority.create subject: @i, authority: 15.6
        Authority.from(@i).should == @a
      end
    end
    context "when provided with a context" do
      describe "it should update the authority" do

      end
    end
  end
end
