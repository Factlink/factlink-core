require 'pavlov_helper'
require_relative '../../../../app/classes/opinion_type.rb'
require_relative '../../../../app/classes/opinion_presenter.rb'
require_relative '../../../../app/interactors/queries/evidence/for_fact_id.rb'

describe Queries::Evidence::ForFactId do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'KillObject', 'Fact'
  end

  def fake_opinion relevance
    mock authority: relevance,
         beliefs: 1,
         disbeliefs: 0
  end

  describe '#validate' do
    it 'requires fact_id to be an integer' do
      expect_validating('a', :weakening).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires fact_id not to be nil' do
      expect_validating(nil, :weakening).
        to fail_validation('fact_id should be an integer string.')
    end

    it 'requires type be :weakening or :supporting' do
      expect_validating('1', :bla).
        to fail_validation('type should be on of these values: [:weakening, :supporting].')
    end
  end

  describe '#call' do
    it 'correctly' do
      fact = mock id: '1'

      dead_fact_relations_with_opinion = [
        mock(:fact_relation1, opinion: fake_opinion(1)),
        mock(:fact_relation2, opinion: fake_opinion(3))
      ]
      dead_comments_with_opinion = [
        mock(:comment1, opinion: fake_opinion(2)),
        mock(:comment2, opinion: fake_opinion(4))
      ]
      type = :weakening
      pavlov_options = { current_user: mock }

      Fact.stub(:[])
          .with(fact.id)
          .and_return(fact)
      Pavlov.stub(:query)
            .with(:'fact_relations/for_fact', fact, type, pavlov_options)
            .and_return dead_fact_relations_with_opinion
      Pavlov.stub(:query)
            .with(:'comments/for_fact', fact, type, pavlov_options)
            .and_return dead_comments_with_opinion

      interactor = Queries::Evidence::ForFactId.new '1', type, pavlov_options

      result = interactor.call

      expected_sorted_result = [
        dead_comments_with_opinion[1],
        dead_fact_relations_with_opinion[1],
        dead_comments_with_opinion[0],
        dead_fact_relations_with_opinion[0]
      ]
      expect(result).to eq expected_sorted_result
    end
  end
end
