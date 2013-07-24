require_relative '../../app/entities/dead_opinion.rb'

describe DeadOpinion do
  let(:o1) { DeadOpinion.new(2,3,5,7) }
  let(:o2) { DeadOpinion.new(11,13,19,23) }
  let(:o3) { DeadOpinion.new(29,31,37,41) }

  describe ".new" do
    subject {DeadOpinion.new(1,1.4,1.5,1.6)}
    its(:believes)    {should eq 1.0}
    its(:disbelieves) {should eq 1.4}
    its(:doubts)      {should eq 1.5}
    its(:authority)   {should eq 1.6}
  end

  describe "attributes" do
    subject { DeadOpinion.new(0,0,0,0) }

    it { should respond_to :believes }
    it { should respond_to :disbelieves }
    it { should respond_to :doubts }
    it { should respond_to :authority }
  end

  it "should not change if you sum it with another one" do
    a = DeadOpinion.new(1,0,0,1)
    b = DeadOpinion.new(0,1,0,1)
    c = a + b
    expect(a.believes).to    eq 1
    expect(b.disbelieves).to eq 1
  end

  it "should be equal to an opinion with the same numbers" do
    expect(DeadOpinion.new(1,2,3,4)).to eq DeadOpinion.new(1,2,3,4)
  end

  it "should be unequal to an opinion with different numbers" do
    a = DeadOpinion.new(1,1,1,1)

    expect(a).to_not eq DeadOpinion.new(2,1,1,1)
    expect(a).to_not eq DeadOpinion.new(1,2,1,1)
    expect(a).to_not eq DeadOpinion.new(1,2,1,1)
    expect(a).to_not eq DeadOpinion.new(1,2,1,1)
  end

  it "should have the proper values when retrieved with for_type without explicit authority" do
    expect(DeadOpinion.for_type(:believes)).to    eq DeadOpinion.new(1,0,0,0)
    expect(DeadOpinion.for_type(:disbelieves)).to eq DeadOpinion.new(0,1,0,0)
    expect(DeadOpinion.for_type(:doubts)).to      eq DeadOpinion.new(0,0,1,0)
  end

  it "should have the proper values when retrieved with for_type with explicit authority" do
    expect(DeadOpinion.for_type(:believes,1.3)).to    eq DeadOpinion.new(1,0,0,1.3)
    expect(DeadOpinion.for_type(:disbelieves,1.3)).to eq DeadOpinion.new(0,1,0,1.3)
    expect(DeadOpinion.for_type(:doubts,1.3)).to      eq DeadOpinion.new(0,0,1,1.3)
  end

  it "should result in the same opinion when you sum it with an opinion with 0 authority" do
    a = DeadOpinion.new(1,2,3,1)
    zero = DeadOpinion.new(1000,1000,1000,0)
    expect(a).to eq a+zero
  end

  it "should have a + which does not crash when adding opinions with 0 authority" do
    DeadOpinion.new(1,2,3)+DeadOpinion.new(1,2,3)
  end

  it "should have a commutative + operation" do
    expect((o1+o2)).to eq (o2+o1)
    expect((o2+o3)).to eq (o3+o2)
    expect((o1+o3)).to eq (o3+o1)
  end

  it "should have an associative + operation" do
    expect(((o1+o2)+o3)).to eq (o1+(o2+o3))
  end

  it "should have a combine operation which does the same as the + operation" do
    expect(DeadOpinion.combine([])).to         eq DeadOpinion.zero
    expect(DeadOpinion.combine([o1])).to       eq o1
    expect(DeadOpinion.combine([o1,o2])).to    eq o1+o2
    expect(DeadOpinion.combine([o1,o2,o3])).to eq o1+o2+o3
  end

  it "should have authorities which add up" do
    expect((o1+o2).authority).to    eq o1.authority + o2.authority
    expect((o1+o2+o3).authority).to eq o1.authority + o2.authority + o3.authority
  end
end
