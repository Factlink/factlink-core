require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/evidence/for_fact_id.rb'

describe Queries::Evidence::ForFactId do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'KillObject', 'Fact'
  end

  describe '#validate' do
    it 'requires fact_id to be an integer' do
      expect_validating(fact_id: 'a', type: :weakening)
        .to fail_validation('fact_id should be an integer string.')
    end

    it 'requires fact_id not to be nil' do
      expect_validating(fact_id: nil, type: :weakening)
        .to fail_validation('fact_id should be an integer string.')
    end

    it 'requires type be :weakening or :supporting' do
      expect_validating(fact_id: '1', type: :bla)
        .to fail_validation('type should be on of these values: [:weakening, :supporting].')
    end
  end

  describe '#call' do
    it 'interleaves and sorts the comments and factrelation it retrieves' do
      fact = mock id: '1'

      fact_relation1 = mock :fact_relation1, impact_opinion: mock(authority: 1)
      fact_relation2 = mock :fact_relation2, impact_opinion: mock(authority: 3)

      comment1 = mock :comment1, impact_opinion: mock(authority: 2)
      comment2 = mock :comment2, impact_opinion: mock(authority: 4)

      type = :weakening
      pavlov_options = { current_user: mock }
      interactor = described_class.new fact_id: '1', type: type,
        pavlov_options: pavlov_options

      Fact.stub(:[])
          .with(fact.id)
          .and_return(fact)
      Pavlov.stub(:old_query)
            .with(:'fact_relations/for_fact', fact, type, pavlov_options)
            .and_return [fact_relation1, fact_relation2]
      Pavlov.stub(:old_query)
            .with(:'comments/for_fact', fact, type, pavlov_options)
            .and_return [comment1, comment2]

      result = interactor.call

      expect(result).to eq [comment2, fact_relation2, comment1, fact_relation1]
    end
  end
end
