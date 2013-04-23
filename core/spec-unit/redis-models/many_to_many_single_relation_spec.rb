require_relative '../../app/redis-models/many_to_many_single_relation'

describe ManyToManySingleRelation do

  let(:relation_key) { mock }
  let(:relation_key_list) { mock }
  let(:many_to_many_single_relation) { ManyToManySingleRelation.new nest_key }

  let(:nest_key) do
    nest_key = mock
    nest_key.stub(:[]).with(:relation).and_return(relation_key)
    nest_key
  end

  describe '.add' do
    it 'adds to_id to relation_key[from_id]' do
      from_id = mock
      to_id = mock

      relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.should_receive(:sadd).with(to_id)

      many_to_many_single_relation.add(from_id, to_id)
    end
  end

  describe '.remove' do
    it 'removes to_id from relation_key[from_id]' do
      from_id = mock
      to_id = mock

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.should_receive(:srem).with(to_id)

      many_to_many_single_relation.remove(from_id, to_id)
    end
  end

  describe '.ids' do
    it 'returns the ids pointed to by from_id' do
      from_id = mock
      ids = mock

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.should_receive(:smembers).and_return(ids)

      expect(many_to_many_single_relation.ids(from_id)).to eq ids
    end
  end

  describe '.has?' do
    it 'checks if there is a link from from_id to to_id' do
      from_id = mock
      to_id = mock
      result = mock

      relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.stub(:sismember).with(to_id).and_return(result)

      expect(many_to_many_single_relation.has?(from_id, to_id)).to eq result
    end
  end
end
