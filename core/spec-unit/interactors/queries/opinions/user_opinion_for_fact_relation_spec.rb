require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/user_opinion_for_fact_relation.rb'

describe Queries::Opinions::UserOpinionForFactRelation do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Opinion::BaseFactCalculation'
    end

    it 'returns the dead user opinion' do
      fact_relation = mock
      dead_opinion = mock
      base_fact_calculation = mock get_user_opinion: dead_opinion
      query = described_class.new fact_relation

      Opinion::BaseFactCalculation.stub(:new).with(fact_relation)
        .and_return(base_fact_calculation)


      expect(query.call).to eq dead_opinion
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact_relation = mock

      described_class.any_instance.should_receive(:validate_not_nil)
                                  .with(:fact_relation, fact_relation)

      query = described_class.new fact_relation
    end
  end
end
