require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/topics/add_fact'

describe Commands::Topics::AddFact do
  include PavlovSupport

  before do
    stub_classes 'Nest'
  end

  describe '#execute' do
    it 'correctly' do
      fact_id = 1
      command = described_class.new fact_id, '1e'
      key = mock
      score = mock

      command.should_receive(:redis_key).and_return(key)
      command.should_receive(:score).and_return(score)
      key.should_receive(:zadd).with(score, fact_id)

      command.execute
    end
  end

  describe '#score' do
    it 'last generated score is the highest' do
      command = described_class.new 1, '1e'

      old_score = command.score
      sleep 0.001

      expect(command.score).to be > old_score
    end
  end

  describe '#redis_key' do
    it 'calls nest correcly' do
      topic_id = '2a'
      command = described_class.new 1, topic_id
      key = mock
      final_key = mock

      Nest.should_receive(:new).with(:new_topic).and_return(key)
      key.should_receive(:[]).with(topic_id).and_return(key)
      key.should_receive(:[]).with(:facts).and_return(final_key)

      expect(command.redis_key).to eq final_key
    end
  end

  describe '#validation' do
    let(:subject_class) { described_class }
    it 'requires arguments' do
      expect_validating('a', '2e').
        to fail_validation('fact_id should be an integer.')
    end

    it 'requires arguments' do
      expect_validating(1, 1).
        to fail_validation('topic_slug_title should be a string.')
    end
  end
end
