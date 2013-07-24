require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/topics/create'

describe Commands::Topics::Create do
  include PavlovSupport

  describe '#execute' do
    before do
      described_class.any_instance.stub validate: true
      stub_classes 'Topic', 'KillObject'
    end

    it 'calls Topic.create and returns a dead topic' do
      title = mock
      topic = mock
      dead_topic = mock

      Topic.should_receive(:create)
                        .with(title: title)
                        .and_return(topic)

      KillObject.stub(:topic)
                        .with(topic)
                        .and_return(dead_topic)

      command = described_class.new title: title
      result = command.execute

      expect(result).to eq dead_topic
    end
  end

  describe 'validation' do
    it 'requires a title' do
      expect_validating(title: '').
        to fail_validation('title should be a nonempty string.')
    end
  end
end
