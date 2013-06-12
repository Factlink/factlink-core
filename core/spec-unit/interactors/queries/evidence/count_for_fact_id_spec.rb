require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/evidence/count_for_fact_id.rb'

describe Queries::Evidence::CountForFactId do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Fact', 'Comment'
    end

    it 'sums the counts of fact relations and comments' do
      fact = mock(id: '1', data_id: '2a', evidence: [mock])
      Fact.stub(:[]).with(fact.id).and_return(fact)

      Comment.stub(:where).with(fact_data_id: fact.data_id)
        .and_return([mock])

      query = described_class.new fact.id

      expect(query.call).to eq 2
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact_id = '1'

      described_class.any_instance.should_receive(:validate_integer_string)
        .with(:fact_id, fact_id)

      described_class.new fact_id
    end
  end
end
