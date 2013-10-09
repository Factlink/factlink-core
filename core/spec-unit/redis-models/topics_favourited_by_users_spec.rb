require_relative '../../app/redis-models/topics_favourited_by_users'

describe TopicsFavouritedByUsers do

  let(:relation) { double }
  let(:topic_id) { double }
  let(:topics_favourited_by_users) { TopicsFavouritedByUsers.new topic_id, relation }

  describe '.favouritours_count' do
    it 'returns relation.ids' do
      count = 10

      relation.stub(:reverse_count).with(topic_id).and_return(count)

      expect(topics_favourited_by_users.favouritours_count).to eq count
    end
  end

end
