require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/index_topic.rb'

describe Commands::TextSearch::IndexTopic do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      topic = double
      changed = double
      command = described_class.new(topic: topic, changed: changed)

      Pavlov.should_receive(:old_command)
            .with :'text_search/index',
                    topic,
                    :topic,
                    [:title, :slug_title],
                    changed

      command.call
    end
  end
end
