require_relative '../../app/ohm-models/many_to_many_sorted_relation'

describe ManyToManySortedRelation do

  let(:relation_key) { mock }
  let(:reverse_relation_key) { mock }
  let(:relation_key_list) { mock }
  let(:reverse_relation_key_list) { mock }
  let(:many_to_many_relation) { ManyToManySortedRelation.new nest_key }

  let(:nest_key) do
    nest_key = mock
    nest_key.stub(:[]).with(:relation).and_return(relation_key)
    nest_key.stub(:[]).with(:reverse_relation).and_return(reverse_relation_key)
    nest_key
  end

  describe '.add' do
    context "relation does not yet exist" do
      it 'adds to_id to relation_key[from_id] and from_id to reverse_relation_key[to_id] with score' do
        from_id = mock
        to_id = mock
        score = mock

        many_to_many_relation.stub(:has?).and_return(false)

        relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
        reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)

        relation_key_list.should_receive(:zadd).with(score, to_id)
        reverse_relation_key_list.should_receive(:zadd).with(score, from_id)

        many_to_many_relation.add(from_id, to_id, score)
      end
    end

    context "relation already exists" do
      it 'aborts' do
        from_id = mock
        to_id = mock
        score = mock

        many_to_many_relation.stub(:has?).and_return(true)

        many_to_many_relation.add(from_id, to_id, score)
      end
    end
  end

  describe '.replace' do
    context "relation does not yet exist" do
      it 'adds to_id to relation_key[from_id] and from_id to reverse_relation_key[to_id] with score' do
        from_id = mock
        to_id = mock
        score = mock

        many_to_many_relation.stub(:has?).and_return(false)

        relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
        reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)

        relation_key_list.should_receive(:zadd).with(score, to_id)
        reverse_relation_key_list.should_receive(:zadd).with(score, from_id)

        many_to_many_relation.replace(from_id, to_id, score)
      end
    end

    context "relation already exists" do
      it 'adds to_id to relation_key[from_id] and from_id to reverse_relation_key[to_id] with score' do
        from_id = mock
        to_id = mock
        score = mock

        many_to_many_relation.stub(:has?).and_return(true)

        relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
        reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)

        relation_key_list.should_receive(:zadd).with(score, to_id)
        reverse_relation_key_list.should_receive(:zadd).with(score, from_id)

        many_to_many_relation.replace(from_id, to_id, score)
      end
    end
  end

  describe '.remove' do
    it 'removes to_id from relation_key[from_id] and from_id from reverse_relation_key[to_id]' do
      from_id = mock
      to_id = mock

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      reverse_relation_key.should_receive(:[]).with(to_id).and_return(reverse_relation_key_list)

      relation_key_list.should_receive(:zrem).with(to_id)
      reverse_relation_key_list.should_receive(:zrem).with(from_id)

      many_to_many_relation.remove(from_id, to_id)
    end
  end

  describe '.ids' do
    it 'returns the ids pointed to by from_id' do
      from_id = mock
      ids = mock

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.should_receive(:zrange).with(0, -1).and_return(ids)

      expect(many_to_many_relation.ids(from_id)).to eq ids
    end
  end

  describe '.reverse_ids' do
    it 'returns the ids pointed from toward to_id' do
      to_id = mock
      ids = mock

      reverse_relation_key.should_receive(:[]).with(to_id).and_return(reverse_relation_key_list)
      reverse_relation_key_list.should_receive(:zrange).with(0, -1).and_return(ids)

      expect(many_to_many_relation.reverse_ids(to_id)).to eq ids
    end
  end

  describe '.has?' do
    it 'checks if there is a link from from_id to to_id' do
      from_id = mock
      to_id = mock
      result = mock

      relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.stub(:zrank).with(to_id).and_return(result)

      reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)
      reverse_relation_key_list.stub(:sismember).with(from_id).and_return(result)

      expect(many_to_many_relation.has?(from_id, to_id)).to eq true
    end
  end
end
