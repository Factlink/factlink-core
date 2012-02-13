require_relative '../ohm_helper.rb'
require_relative '../../app/ohm-models/authority.rb'

class Item < OurOhm
  attribute :number
  collection :items, SubItem
end

class GraphUser < OurOhm; end

class SubItem < OurOhm
  attribute :number
  reference :item, Item
end

describe Authority do
  let(:i1) { Item.create }
  let(:i2) { Item.create }
  let(:gu1) { GraphUser.create }
  let(:gu2) { GraphUser.create }

  before do
    Authority.reset_calculators
  end
  after :all do
    begin
      load_global_authority
    rescue
    end
  end

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
        Authority.from(Item.new).to_f.should == 0
      end
      it do
        a = Authority.from(i1, for: gu1)
        a.to_f.should == 0
      end
    end
    context "for a defined authority" do
      before do
        @a = Authority.create subject: i1, authority: 15.6
      end
      it do
        Authority.from(i1).should == @a
      end
      it "should work when quiried with classname and id" do
        Authority.from(Item: i1.id).should == @a
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
    it "should return 0.0 when no calculator is defined" do
      Authority.calculated_from_authority(i1).should == 0
    end

    describe "should work when provided with lambdas" do
      before do
        Authority.calculate_from :Item,
            select: ->(i){ i.items },
            select_after: ->(select){ select.map { |x| x.number.to_f } },
            result: ->(select_after){ select_after.inject(0) { |result, item| result + item } },
            total: ->(result){ [1, result].max }
      end

      it do
        i = Item.create
        SubItem.create  item: i, number: 2
        SubItem.create  item: i, number: 2
        Authority.calculated_from_authority(i).to_f.should == 4
      end
      it do
        i = Item.create
        Authority.calculated_from_authority(i).should == 1
      end
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
    it "should use the calculate from calculate_from" do
      Authority.calculate_from Item do |i|
        i.number
      end
      i1.number = 10
      Authority.recalculate_from i1
      Authority.from(i1).to_f.should == 10
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
end
