require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/index_fact_data.rb'

describe Commands::TextSearch::IndexFactData do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      fact_data = double
      changed = double
      command = described_class.new(fact_data: fact_data, changed: changed)

      Pavlov.should_receive(:command)
            .with(:'text_search/index',
                      object: fact_data, type_name: :factdata,
                      fields: [:displaystring, :title], fields_changed: changed)

      command.call
    end
  end
end
