require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/evidence/count_for_fact.rb'

describe Queries::Evidence::CountForFact do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Fact', 'Comment'
    end

    it 'sums the counts of fact relations and comments' do
      fact = double(id: '1', data_id: '2a', evidence: [double])
      query = described_class.new fact: fact

      Comment.stub(:where).with(fact_data_id: fact.data_id)
        .and_return(double(count: 1)) # count instead of size: http://two.mongoid.org/docs/querying/finders.html#count

      expect(query.call).to eq 2
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      expect_validating(fact: nil)
        .to fail_validation 'fact should not be nil.'
    end
  end
end
