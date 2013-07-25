require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/opinions/user_opinion_for_fact_relation.rb'

describe Queries::Opinions::UserOpinionForFactRelation do
  include PavlovSupport

  describe '#call' do
    before do
      stub_classes 'Opinion::Store', 'HashStore::Redis'
    end

    it 'returns the dead user opinion' do
      fact_relation = mock(id: mock)
      dead_opinion = mock
      opinion_store = mock
      query = described_class.new fact_relation

      HashStore::Redis.stub new: mock
      Opinion::Store.stub(:new).with(HashStore::Redis.new)
        .and_return(opinion_store)

      opinion_store.stub(:retrieve).with(:FactRelation, fact_relation.id, :user_opinion)
        .and_return(dead_opinion)

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
