require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/index_topic.rb'

describe Commands::TextSearch::IndexTopic do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      topic = double
      changed = double
      command = described_class.new(topic: topic, changed: changed)

      Pavlov.should_receive(:command)
            .with(:'text_search/index',
                      object: topic, type_name: :topic,
                      fields: [:title, :slug_title], fields_changed: changed)

      command.call
    end
  end
end
