require_relative '../../app/redis-models/directed_relations_sorted_with_reverse'

describe DirectedRelationsSortedWithReverse do

  let(:relation_key) { mock }
  let(:reverse_relation_key) { mock }
  let(:relation_key_list) { mock }
  let(:reverse_relation_key_list) { mock }
  let(:directed_relations_sorted_with_reverse) { DirectedRelationsSortedWithReverse.new nest_key }

  let(:nest_key) do
    nest_key = double
    nest_key.stub(:[]).with(:relation).and_return(relation_key)
    nest_key.stub(:[]).with(:reverse_relation).and_return(reverse_relation_key)
    nest_key
  end

  describe '.add' do
    context "relation does not yet exist" do
      it 'adds to_id to relation_key[from_id] and from_id to reverse_relation_key[to_id] with score' do
        from_id = double
        to_id = double
        score = double

        directed_relations_sorted_with_reverse.stub(:has?).and_return(false)

        relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
        reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)

        relation_key_list.should_receive(:zadd).with(score, to_id)
        reverse_relation_key_list.should_receive(:zadd).with(score, from_id)

        directed_relations_sorted_with_reverse.add(from_id, to_id, score)
      end
    end

    context "relation already exists" do
      it 'aborts' do
        from_id = double
        to_id = double
        score = double

        directed_relations_sorted_with_reverse.stub(:has?).and_return(true)

        directed_relations_sorted_with_reverse.add(from_id, to_id, score)
      end
    end
  end

  describe '.replace' do
    context "relation does not yet exist" do
      it 'adds to_id to relation_key[from_id] and from_id to reverse_relation_key[to_id] with score' do
        from_id = double
        to_id = double
        score = double

        directed_relations_sorted_with_reverse.stub(:has?).and_return(false)

        relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
        reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)

        relation_key_list.should_receive(:zadd).with(score, to_id)
        reverse_relation_key_list.should_receive(:zadd).with(score, from_id)

        directed_relations_sorted_with_reverse.replace(from_id, to_id, score)
      end
    end

    context "relation already exists" do
      it 'adds to_id to relation_key[from_id] and from_id to reverse_relation_key[to_id] with score' do
        from_id = double
        to_id = double
        score = double

        directed_relations_sorted_with_reverse.stub(:has?).and_return(true)

        relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
        reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)

        relation_key_list.should_receive(:zadd).with(score, to_id)
        reverse_relation_key_list.should_receive(:zadd).with(score, from_id)

        directed_relations_sorted_with_reverse.replace(from_id, to_id, score)
      end
    end
  end

  describe '.remove' do
    it 'removes to_id from relation_key[from_id] and from_id from reverse_relation_key[to_id]' do
      from_id = double
      to_id = double

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      reverse_relation_key.should_receive(:[]).with(to_id).and_return(reverse_relation_key_list)

      relation_key_list.should_receive(:zrem).with(to_id)
      reverse_relation_key_list.should_receive(:zrem).with(from_id)

      directed_relations_sorted_with_reverse.remove(from_id, to_id)
    end
  end

  describe '.ids' do
    it 'returns the ids pointed to by from_id' do
      from_id = double
      ids = double

      relation_key.should_receive(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.should_receive(:zrange).with(0, -1).and_return(ids)

      expect(directed_relations_sorted_with_reverse.ids(from_id)).to eq ids
    end
  end

  describe '.reverse_ids' do
    it 'returns the ids pointed from toward to_id' do
      to_id = double
      ids = double

      reverse_relation_key.should_receive(:[]).with(to_id).and_return(reverse_relation_key_list)
      reverse_relation_key_list.should_receive(:zrange).with(0, -1).and_return(ids)

      expect(directed_relations_sorted_with_reverse.reverse_ids(to_id)).to eq ids
    end
  end

  describe '.has?' do
    it 'checks if there is a link from from_id to to_id' do
      from_id = double
      to_id = double
      result = double

      relation_key.stub(:[]).with(from_id).and_return(relation_key_list)
      relation_key_list.stub(:zrank).with(to_id).and_return(result)

      reverse_relation_key.stub(:[]).with(to_id).and_return(reverse_relation_key_list)
      reverse_relation_key_list.stub(:sismember).with(from_id).and_return(result)

      expect(directed_relations_sorted_with_reverse.has?(from_id, to_id)).to eq true
    end
  end
end
