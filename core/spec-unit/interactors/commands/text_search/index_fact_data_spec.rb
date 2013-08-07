require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/text_search/index_fact_data.rb'

describe Commands::TextSearch::IndexFactData do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      fact_data = double
      command = described_class.new(factdata: fact_data)

      Pavlov.should_receive(:old_command)
            .with :elastic_search_index_for_text_search,
                    fact_data,
                    :factdata,
                    [:displaystring, :title]

      command.call
    end
  end
end
