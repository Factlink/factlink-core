require_relative '../../app/redis-models/user_favourited_topics'

describe UserFavouritedTopics do

  let(:relation) { double }
  let(:graph_user_id) { double }
  let(:topic_id) { double }
  let(:ids) { double }
  let(:user_favourited_topics) { UserFavouritedTopics.new graph_user_id, relation }

  describe '.favourite' do
    it 'calls relation.add' do
      relation.should_receive(:add).with(graph_user_id, topic_id)
      user_favourited_topics.favourite topic_id
    end
  end

  describe '.unfavourite' do
    it 'calls relation.remove' do
      relation.should_receive(:remove).with(graph_user_id, topic_id)
      user_favourited_topics.unfavourite topic_id
    end
  end

  describe '.topic_ids' do
    it 'returns relation.ids' do
      relation.should_receive(:ids).with(graph_user_id).and_return(ids)
      result = user_favourited_topics.topic_ids
      expect(result).to eq ids
    end
  end

  describe '.favourited?' do
    it 'calls relation.remove' do
      boolean = double

      relation.should_receive(:has?).with(graph_user_id, topic_id).and_return(boolean)
      result = user_favourited_topics.favourited? topic_id

      expect(result).to eq boolean
    end
  end

end
