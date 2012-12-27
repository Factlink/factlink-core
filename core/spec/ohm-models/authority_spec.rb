require_relative '../ohm_helper.rb'
require_relative '../../app/ohm-models/authority.rb'


class GraphUser < OurOhm; end

class Item < OurOhm; end # needed because of removed const_missing from ohm

class SubItem < OurOhm
  attribute :number
  reference :item, Item
end

class Item < OurOhm
  attribute :number
  collection :items, SubItem
end

describe Authority do
  let(:i1) { Item.create }
  let(:i2) { Item.create }
  let(:gu1) { GraphUser.create }
  let(:gu2) { GraphUser.create }

  describe :to_f do
    it "should return a float" do
      Authority.new.to_f.should be_a(Float)
    end
    context "initially" do
      its(:to_f) { should == 0 }
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
        Authority.from(Item.create).to_f.should == 0
      end
      it do
        a = Authority.from(i1, for: gu1)
        a.to_f.should == 0
      end
    end
    context "for a defined authority" do
      before do
        Authority.from(i1) << 15.6
      end
      it do
        Authority.from(i1).to_f.should == 15.6
      end
    end
    it "should return an authority for the subject" do
      Authority.from(i1).subject.should == i1
    end
    it "should return the authority from the user, when provided" do
      a = Authority.from(i1, for: gu1)
      a.user.should == gu1
    end
  end
  describe ".on" do
    context "for an undefined authority" do
      it do
        Authority.on(Item.create).to_f.should == 0
      end
      it do
        a = Authority.on(i1, for: gu1)
        a.to_f.should == 0
      end
    end
    context "for a defined authority" do
      before do
        Authority.on(i1) << 15.6
      end
      it do
        Authority.on(i1).to_f.should == 15.6
      end
    end
    it "should return an authority for the subject" do
      Authority.on(i1).subject.should == i1
    end
    it "should return the authority from the user, when provided" do
      a = Authority.on(i1, for: gu1)
      a.user.should == gu1
    end
  end
  describe :<< do
    context "without for" do
      it "should set the authority" do
        Authority.from(i1) << 21
        Authority.from(i1).to_f.should == 21
      end
      it "should update the authority" do
        Authority.from(i1) << 23
        Authority.from(i1) << 21
        Authority.from(i1).to_f.should == 21
      end
      it "should not influence the from with for" do
        Authority.from(i1) << 10
        Authority.from(i1,for: gu1).to_f.should == 0
      end
    end
    context "with for" do
      it "should set the authority" do
        Authority.from(i1, for: gu1) << 21
        Authority.from(i1, for: gu1).to_f.should == 21
      end
    end
  end

  describe ".all_from" do
    it "should return an empty list when no authorities are defined on the subject" do
      Authority.all_from(i1).all.should =~ []
    end
    it "should return all authority objects" do
      Authority.from(i1, for: gu1) << 2
      Authority.from(i1, for: gu2) << 3
      Authority.all_from(i1).all.should =~ [Authority.from(i1, for:gu1), Authority.from(i1,for:gu2)]
    end
  end
  describe ".all_on" do
    it "should return an empty list when no authorities are defined on the subject" do
      Authority.all_on(i1).all.should =~ []
    end
    it "should return all authority objects" do
      Authority.on(i1, for: gu1) << 2
      Authority.on(i1, for: gu2) << 3
      Authority.all_on(i1).all.should =~ [Authority.on(i1, for:gu1), Authority.on(i1,for:gu2)]
    end
  end

  describe ".run_calculation" do
    context "when no mapreducers are provided"do
      it "should do nothing" do
        i1.number = 2
        Authority.run_calculation []
        Authority.from(i1).to_f.should == 0.0
      end
    end
    it "should use the mapreducers provided" do
      calculator = mock(:calculator)
      calculator.should_receive(:process_all).once
      some_class = mock(:SomeClass)
      some_class.should_receive(:new).and_return(calculator)
      Authority.run_calculation [some_class]
    end
  end
end
