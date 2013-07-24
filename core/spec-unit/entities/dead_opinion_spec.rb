require_relative '../../app/entities/dead_opinion.rb'

describe DeadOpinion do
  let(:o1) { DeadOpinion.new(2,3,5,7) }
  let(:o2) { DeadOpinion.new(11,13,19,23) }
  let(:o3) { DeadOpinion.new(29,31,37,41) }

  describe ".new" do
    subject {DeadOpinion.new(1,1.4,1.5,1.6)}
    its(:believes) {should == 1.0}
    its(:disbelieves) {should == 1.4}
    its(:doubts) {should == 1.5}
    its(:authority) {should == 1.6}
  end

  describe "attributes" do
    subject { DeadOpinion.new(0,0,0,0) }

    it { should respond_to :believes }
    it { should respond_to :disbelieves }
    it { should respond_to :doubts }
    it { should respond_to :authority }

    it { expect {subject.believes = 1.3}.to change{subject.believes}.to(1.3) }
    it { expect {subject.disbelieves = 1.3}.to change{subject.disbelieves}.to(1.3) }
    it { expect {subject.doubts = 1.3}.to change{subject.doubts}.to(1.3) }
    it { expect {subject.authority = 1.3}.to change{subject.authority}.to(1.3) }
  end

  it "should not change if you sum it with another one" do
    a = DeadOpinion.new(1,0,0,1)
    b = DeadOpinion.new(0,1,0,1)
    c = a + b
    a.believes.should == 1
    b.disbelieves.should == 1
  end

  it "should be equal to an opinion with the same numbers" do
    DeadOpinion.new(1,2,3,4).should == DeadOpinion.new(1,2,3,4)
  end

  it "should be unequal to an opinion with different numbers" do
    a = DeadOpinion.new(1,1,1,1)

    a.should_not == DeadOpinion.new(2,1,1,1)
    a.should_not == DeadOpinion.new(1,2,1,1)
    a.should_not == DeadOpinion.new(1,2,1,1)
    a.should_not == DeadOpinion.new(1,2,1,1)
  end

  it "should have the proper values when retrieved with for_type without explicit authority" do
    DeadOpinion.for_type(:believes).should    == DeadOpinion.new(1,0,0,0)
    DeadOpinion.for_type(:disbelieves).should == DeadOpinion.new(0,1,0,0)
    DeadOpinion.for_type(:doubts).should     == DeadOpinion.new(0,0,1,0)
  end

  it "should have the proper values when retrieved with for_type with explicit authority" do
    DeadOpinion.for_type(:believes,1.3).should    == DeadOpinion.new(1,0,0,1.3)
    DeadOpinion.for_type(:disbelieves,1.3).should == DeadOpinion.new(0,1,0,1.3)
    DeadOpinion.for_type(:doubts,1.3).should      == DeadOpinion.new(0,0,1,1.3)
  end

  it "should result in the same opinion when you sum it with an opinion with 0 authority" do
    a = DeadOpinion.new(1,2,3,1)
    zero = DeadOpinion.new(1000,1000,1000,0)
    a.should == a+zero
  end

  it "should have a + which does not crash when adding opinions with 0 authority" do
    DeadOpinion.new(1,2,3)+DeadOpinion.new(1,2,3)
  end

  it "should have a commutative + operation" do
    (o1+o2).should == (o2+o1)
    (o2+o3).should == (o3+o2)
    (o1+o3).should == (o3+o1)
  end

  it "should have an associative + operation" do
    ((o1+o2)+o3).should == (o1+(o2+o3))
  end

  it "should have a combine operation which does the same as the + operation" do
    DeadOpinion.combine([]).should == DeadOpinion.zero
    DeadOpinion.combine([o1]).should == o1
    DeadOpinion.combine([o1,o2]).should == o1+o2
    DeadOpinion.combine([o1,o2,o3]).should == o1+o2+o3
  end

  it "should have authorities which add up" do
    (o1+o2).authority.should == o1.authority + o2.authority
    (o1+o2+o3).authority.should == o1.authority + o2.authority + o3.authority
  end
end
