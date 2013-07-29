require_relative '../../app/entities/dead_opinion.rb'

describe DeadOpinion do
  let(:opinion1) { DeadOpinion.new(2,3,5,7) }
  let(:opinion2) { DeadOpinion.new(11,13,19,23) }
  let(:opinion3) { DeadOpinion.new(29,31,37,41) }

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
    opinion = DeadOpinion.new(1,1,1,1)

    expect(opinion).to_not eq DeadOpinion.new(2,1,1,1)
    expect(opinion).to_not eq DeadOpinion.new(1,2,1,1)
    expect(opinion).to_not eq DeadOpinion.new(1,2,1,1)
    expect(opinion).to_not eq DeadOpinion.new(1,2,1,1)
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
    opinion = DeadOpinion.new(1,2,3,1)
    zero    = DeadOpinion.new(1000,1000,1000,0)

    expect(opinion).to eq opinion+zero
  end

  it "should have a + which does not crash when adding opinions with 0 authority" do
    DeadOpinion.new(1,2,3)+DeadOpinion.new(1,2,3)
  end

  it "should have a commutative + operation" do
    expect((opinion1+opinion2)).to eq (opinion2+opinion1)
    expect((opinion2+opinion3)).to eq (opinion3+opinion2)
    expect((opinion1+opinion3)).to eq (opinion3+opinion1)
  end

  it "should have an associative + operation" do
    expect(((opinion1+opinion2)+opinion3)).to eq (opinion1+(opinion2+opinion3))
  end

  it "should have a combine operation which does the same as the + operation" do
    expect(DeadOpinion.combine([])).to                           eq DeadOpinion.zero
    expect(DeadOpinion.combine([opinion1])).to                   eq opinion1
    expect(DeadOpinion.combine([opinion1,opinion2])).to          eq opinion1+opinion2
    expect(DeadOpinion.combine([opinion1,opinion2,opinion3])).to eq opinion1+opinion2+opinion3
  end

  it "should have authorities which add up" do
    expect((opinion1+opinion2).authority).to          eq opinion1.authority + opinion2.authority
    expect((opinion1+opinion2+opinion3).authority).to eq opinion1.authority + opinion2.authority + opinion3.authority
  end

  describe "#to_h" do
    it "creates a hash with believes, disbelieves, doubts, and authority" do
      opinion = DeadOpinion.new(0.1,0.2,0.7,4)

      expect(opinion.to_h).to eq({
        believes: 0.1,
        disbelieves: 0.2,
        doubts: 0.7,
        authority: 4.0
      })
    end
  end

  describe ".from_hash" do
    it "creates a DeadOpinion based on its hash serialization" do
      opinion = DeadOpinion.new(0.1,0.2,0.7,4)
      hash = opinion.to_h

      expect(DeadOpinion.from_hash(hash)).to eq(opinion)
    end
  end
end
