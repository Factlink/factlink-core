require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/topics/add_fact'

describe Commands::Topics::AddFact do
  include PavlovSupport

  before do
    stub_classes 'Nest'
  end

  describe '#execute' do
    it 'correctly' do
      fact_id = "1"
      command = described_class.new fact_id, '1e', mock
      key = mock
      score = mock

      command.should_receive(:redis_key).and_return(key)
      command.should_receive(:score).and_return(score)
      key.should_receive(:zadd).with(score, fact_id)

      command.execute
    end
  end

  describe '#redis_key' do
    before do
      stub_classes("Topic")
    end

    it 'calls nest correcly' do
      topic_slug_title = '2a'
      score = Time.now
      nest_instance = mock
      key = mock
      final_key = mock
      command = described_class.new "1", topic_slug_title, score

      Topic.should_receive(:redis).and_return(nest_instance)
      nest_instance.should_receive(:[]).with(topic_slug_title).and_return(key)
      key.should_receive(:[]).with(:facts).and_return(final_key)

      expect(command.redis_key).to eq final_key
    end
  end

  describe '.score' do
    before do
      stub_classes("Ohm::Model::TimestampedSet")
    end

    it 'calls timestamped_set.current_time with score' do
      score = mock
      current_time = mock

      command = described_class.new "1", "slug", score

      Ohm::Model::TimestampedSet.should_receive(:current_time).and_return(current_time)

      expect(command.score).to eq current_time
    end
  end

  describe '#validation' do
    let(:subject_class) { described_class }
    it 'requires arguments' do
      expect_validating('a', '2e', Time.now).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires arguments' do
      expect_validating("1", 1, Time.now).
        to fail_validation('topic_slug_title should be a string.')
    end
  end
end
