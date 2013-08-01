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
      title = double
      topic = double
      dead_topic = double

      Topic.should_receive(:create)
                        .with(title: title)
                        .and_return(topic)

      KillObject.stub(:topic)
                        .with(topic)
                        .and_return(dead_topic)

      command = described_class.new title
      result = command.execute

      expect(result).to eq dead_topic
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      title = double

      described_class.any_instance.should_receive(:validate_nonempty_string)
                                  .with(:title, title)

      command = described_class.new title
    end
  end
end
