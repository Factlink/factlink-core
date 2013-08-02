require_relative '../../app/redis-models/directed_relations_with_reverse'

describe DirectedRelationsWithReverse do

  let(:relation_key) { double }
  let(:reverse_relation_key) { double }
  let(:relation_key_list) { double }
  let(:reverse_relation_key_list) { double }
  let(:directed_relations_with_reverse) { DirectedRelationsWithReverse.new nest_key }

  let(:nest_key) do
    nest_key = double
    nest_key.stub(:[]).with(:relation).and_return(relation_key)
    nest_key.stub(:[]).with(:reverse_relation).and_return(reverse_relation_key)
    nest_key
  end

  describe '.add' do
    it 'adds to_id to relation_key[from_id] and from_id to reverse_relation_key[to_id]' do
      from_id = double
      to_id = double

      relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
      reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)

      relation_key_list.should_receive(:sadd).with(to_id)
      reverse_relation_key_list.should_receive(:sadd).with(from_id)

      directed_relations_with_reverse.add(from_id, to_id)
    end
  end

  describe '.remove' do
    it 'removes to_id from relation_key[from_id] and from_id from reverse_relation_key[to_id]' do
      from_id = double
      to_id = double

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      reverse_relation_key.should_receive(:[]).with(to_id).and_return(reverse_relation_key_list)

      relation_key_list.should_receive(:srem).with(to_id)
      reverse_relation_key_list.should_receive(:srem).with(from_id)

      directed_relations_with_reverse.remove(from_id, to_id)
    end
  end

  describe '.ids' do
    it 'returns the ids pointed to by from_id' do
      from_id = double
      ids = double

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.should_receive(:smembers).and_return(ids)

      expect(directed_relations_with_reverse.ids(from_id)).to eq ids
    end
  end

  describe '.reverse_ids' do
    it 'returns the ids pointed from toward to_id' do
      to_id = double
      ids = double

      reverse_relation_key.should_receive(:[]).with(to_id).and_return(reverse_relation_key_list)
      reverse_relation_key_list.should_receive(:smembers).and_return(ids)

      expect(directed_relations_with_reverse.reverse_ids(to_id)).to eq ids
    end
  end

  describe '.has?' do
    it 'checks if there is a link from from_id to to_id' do
      from_id = double
      to_id = double
      result = double

      relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.stub(:sismember).with(to_id).and_return(result)

      reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)
      reverse_relation_key_list.stub(:sismember).with(from_id).and_return(result)

      expect(directed_relations_with_reverse.has?(from_id, to_id)).to eq result
    end
  end
end
