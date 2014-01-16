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

      comment1 = double :comment1, votes: {believes: 2, disbelieves: 1}
      comment2 = double :comment2, votes: {believes: 4, disbelieves: 0}

      type = :disbelieves
      pavlov_options = { current_user: double }
      interactor = described_class.new fact_id: '1', type: type,
                                       pavlov_options: pavlov_options

      Fact.stub(:[])
          .with(fact.id)
          .and_return(fact)
      Pavlov.stub(:query)
            .with(:'comments/for_fact',
                      fact: fact, pavlov_options: pavlov_options)
            .and_return [comment1, comment2]

      result = interactor.call

      expect(result).to eq [comment2, comment1]
    end
  end
end
