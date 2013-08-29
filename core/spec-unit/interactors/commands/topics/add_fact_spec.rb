require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/topics/add_fact'

describe Commands::Topics::AddFact do
  include PavlovSupport

  before do
    stub_classes 'Nest', 'Ohm::Model::TimestampedSet', 'Topic'
  end

  describe '#execute' do
    it 'correctly' do
      fact_id = "1"
      command = described_class.new fact_id: fact_id, topic_slug_title: '1e',
        score: ''
      key = double
      score = double

      command.should_receive(:redis_key).and_return(key)
      command.should_receive(:fixed_score).and_return(score)
      key.should_receive(:zadd).with(score, fact_id)

      command.execute
    end
  end

  describe '#redis_key' do
    it 'calls nest correcly' do
      topic_slug_title = '2a'
      score = Time.now
      nest_instance = double
      key = double
      final_key = double
      command = described_class.new fact_id: '1',
        topic_slug_title: topic_slug_title, score: score.to_s

      Topic.stub redis: nest_instance
      nest_instance.should_receive(:[]).with(topic_slug_title).and_return(key)
      key.should_receive(:[]).with(:facts).and_return(final_key)

      expect(command.redis_key).to eq final_key
    end
  end

  describe '.fixed_score' do
    it 'calls timestamped_set.current_time with score' do
      score = '123'
      current_time = double

      expect(score.blank?).to be_false

      command = described_class.new fact_id: '1', topic_slug_title: 'slug',
        score: score

      Ohm::Model::TimestampedSet.stub(:current_time)
                                .with(score)
                                .and_return(current_time)

      expect(command.fixed_score).to eq current_time
    end

    it 'calls timestamped_set.current_time with nil if score is an empty string' do
      score = ''
      current_time = double

      command = described_class.new fact_id: '1', topic_slug_title: 'slug',
        score: score

      Ohm::Model::TimestampedSet.stub(:current_time)
                                .with(nil)
                                .and_return(current_time)

      expect(command.fixed_score).to eq current_time
    end
  end

  describe 'validation' do
    it :fact_id do
      expect_validating(fact_id: 'a', topic_slug_title: '2e', score: Time.now)
        .to fail_validation('fact_id should be an integer string.')
    end

    it :topic_slug_title do
      expect_validating(fact_id: '1', topic_slug_title: 1, score: Time.now)
        .to fail_validation('topic_slug_title should be a string.')
    end

    it :score do
      expect_validating(fact_id: '1', topic_slug_title: '2e', score: nil)
        .to fail_validation('score should be a string.')
    end
  end
end
