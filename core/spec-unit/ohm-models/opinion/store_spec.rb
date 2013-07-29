require_relative '../../../app/classes/hash_store/in_memory.rb'
require_relative '../../../app/ohm-models/opinion/store.rb'
require_relative '../../../app/entities/dead_opinion.rb'

describe Opinion::Store do
  let(:opinion)  { DeadOpinion.new 1,3,5,10}
  let(:opinion2) { DeadOpinion.new 4,1,3,5}

  it "stores an opinion"  do
    subject.store "Fact", 3 , "useropinion", opinion
  end

  it "can retrieve an opinion from the store" do
    subject.store "Fact", 3 , "useropinion", opinion
    retrieved_opinion = subject.retrieve("Fact", 3 , "useropinion")
    expect(retrieved_opinion).to eq opinion
  end
  it "can store and retrieve multiple opinions" do
    subject.store "Fact", 3 , "useropinion", opinion
    subject.store "Fact", 4 , "useropinion", opinion2
    retrieved_opinion = subject.retrieve("Fact", 3 , "useropinion")
    expect(retrieved_opinion).to eq opinion
  end
  it "retrieves opinion zero of no opinion is set" do
    retrieved_opinion = subject.retrieve("Fact", 3 , "useropinion")
    expect(retrieved_opinion).to eq DeadOpinion.zero
  end
end
