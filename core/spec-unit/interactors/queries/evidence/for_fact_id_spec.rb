require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/evidence/for_fact_id.rb'

describe Queries::Evidence::ForFactId do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'KillObject', 'Fact'
  end

  describe '#call' do
    it 'interleaves and sorts the comments and factrelation it retrieves' do
      fact = double id: '1'

      fact_relation1 = double :fact_relation1, impact_opinion: double(authority: 1)
      fact_relation2 = double :fact_relation2, impact_opinion: double(authority: 3)

      comment1 = double :comment1, impact_opinion: double(authority: 2)
      comment2 = double :comment2, impact_opinion: double(authority: 4)

      type = :weakening
      pavlov_options = { current_user: double }
      interactor = described_class.new fact_id: '1', type: type,
                                       pavlov_options: pavlov_options

      Fact.stub(:[])
          .with(fact.id)
          .and_return(fact)
      Pavlov.stub(:query)
            .with(:'fact_relations/for_fact',
                      fact: fact, pavlov_options: pavlov_options)
            .and_return [fact_relation1, fact_relation2]
      Pavlov.stub(:query)
            .with(:'comments/for_fact',
                      fact: fact, pavlov_options: pavlov_options)
            .and_return [comment1, comment2]

      result = interactor.call

      expect(result).to eq [comment2, fact_relation2, comment1, fact_relation1]
    end
  end
end
