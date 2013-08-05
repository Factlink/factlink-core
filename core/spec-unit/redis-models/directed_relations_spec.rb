require_relative '../../app/redis-models/directed_relations'

describe DirectedRelations do

  let(:relation_key) { double }
  let(:relation_key_list) { double }
  let(:directed_relations) { DirectedRelations.new nest_key }

  let(:nest_key) do
    nest_key = double
    nest_key.stub(:[]).with(:relation).and_return(relation_key)
    nest_key
  end

  describe '.add' do
    it 'adds to_id to relation_key[from_id]' do
      from_id = double
      to_id = double

      relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.should_receive(:sadd).with(to_id)

      directed_relations.add(from_id, to_id)
    end
  end

  describe '.remove' do
    it 'removes to_id from relation_key[from_id]' do
      from_id = double
      to_id = double

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.should_receive(:srem).with(to_id)

      directed_relations.remove(from_id, to_id)
    end
  end

  describe '.ids' do
    it 'returns the ids pointed to by from_id' do
      from_id = double
      ids = double

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.should_receive(:smembers).and_return(ids)

      expect(directed_relations.ids(from_id)).to eq ids
    end
  end

  describe '.has?' do
    it 'checks if there is a link from from_id to to_id' do
      from_id = double
      to_id = double
      result = double

      relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.stub(:sismember).with(to_id).and_return(result)

      expect(directed_relations.has?(from_id, to_id)).to eq result
    end
  end
end
