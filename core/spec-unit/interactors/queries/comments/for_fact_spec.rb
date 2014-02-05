require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/comments/for_fact.rb'

describe Queries::Comments::ForFact do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'KillObject', 'Fact', 'OpinionType'
    stub_const 'Backend::SubComments', Module.new
  end

  describe '#call' do
    it 'correctly' do
      comment = double(id: '2a', class: 'Comment')
      fact = double(data_id: '10')
      dead_comment = double
      pavlov_options = { current_user: double }
      query = described_class.new fact_data_id: fact.data_id, pavlov_options: pavlov_options

      Pavlov.should_receive(:query)
            .with(:'comments/by_ids',
                      by: :fact_data_id, ids: [fact.data_id], pavlov_options: pavlov_options)
            .and_return([dead_comment])

      expect(query.call).to eq [dead_comment]
    end
  end
end
